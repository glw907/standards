#!/usr/bin/env bash
# Builds a small Go repo with two decision records and a feature branch that adds a CSV import.
set -euo pipefail
g() { git -c user.name=Eval -c user.email=eval@example.com "$@"; }

git init -q -b main
mkdir -p cmd/members internal/store internal/importer docs/decisions
cat > go.mod <<'EOF'
module example.com/members

go 1.24

require github.com/google/uuid v1.6.0
EOF
cat > go.sum <<'EOF'
github.com/google/uuid v1.6.0 h1:NIvaJDMOsjHA8n1jAhLSgzrAzy1Hgr+hNrb57e+94F0=
github.com/google/uuid v1.6.0/go.mod h1:TIyPZe4MgqvfeYDBFedMoGGpEw/LqOeaOT+nhxU+yHo=
EOF
cat > docs/decisions/0001-integer-member-ids.md <<'EOF'
# 1. Member IDs are integers

Status: Superseded by 0002

## Context

The first store was SQLite, and its rowid was the simplest key.

## Decision

A member's ID is the integer SQLite assigns as its `INTEGER PRIMARY KEY`. Code that adds a member
leaves the ID empty and reads it back after the insert.

## Consequences

IDs are short and readable, but they reveal how many members the club has.
EOF
cat > docs/decisions/0002-store-mints-member-ids.md <<'EOF'
# 2. The store mints member IDs

Status: Accepted

## Context

Integer IDs revealed the club's size and clashed when two exports were merged.

## Decision

A member's ID is a UUIDv7 string, and only `store.NewID` mints one. No other package creates an ID,
so every ID sorts by the time it was made and one change covers every way a member is added.

## Consequences

Code that adds a member calls `store.NewID` before `store.Insert`.
EOF
cat > internal/store/store.go <<'EOF'
// Package store keeps the club's members.
package store

import (
	"context"
	"fmt"

	"github.com/google/uuid"
)

// Member is one club member.
type Member struct {
	ID    string
	Name  string
	Email string
}

// NewID mints a member ID.
func NewID() string {
	return uuid.Must(uuid.NewV7()).String()
}

// Store holds members by ID.
type Store struct {
	members map[string]Member
}

// New returns an empty store.
func New() *Store {
	return &Store{members: map[string]Member{}}
}

// Insert adds m. It fails if a member with m's ID exists.
func (s *Store) Insert(_ context.Context, m Member) error {
	if _, ok := s.members[m.ID]; ok {
		return fmt.Errorf("insert member %s: exists", m.ID)
	}
	s.members[m.ID] = m
	return nil
}
EOF
cat > cmd/members/main.go <<'EOF'
// Command members manages the club's member list.
package main

import (
	"context"
	"fmt"
	"os"

	"example.com/members/internal/store"
)

func main() {
	ctx := context.Background()
	s := store.New()
	if len(os.Args) == 4 && os.Args[1] == "add" {
		m := store.Member{ID: store.NewID(), Name: os.Args[2], Email: os.Args[3]}
		if err := s.Insert(ctx, m); err != nil {
			fmt.Fprintf(os.Stderr, "members: %v\n", err)
			os.Exit(1)
		}
		return
	}
	fmt.Fprintln(os.Stderr, "usage: members add <name> <email>")
	os.Exit(2)
}
EOF
g add -A
g commit -q -m "Add members with store-minted IDs"

git checkout -q -b feature
cat > internal/importer/csv.go <<'EOF'
// Package importer adds members from a CSV export.
package importer

import (
	"context"
	"encoding/csv"
	"fmt"
	"io"

	"github.com/google/uuid"

	"example.com/members/internal/store"
)

// Skipped is a row the import left out, with its line number in the file.
type Skipped struct {
	Line   int
	Reason string
}

// CSV adds each name,email row in r to s and returns the rows it skipped.
func CSV(ctx context.Context, r io.Reader, s *store.Store) ([]Skipped, error) {
	cr := csv.NewReader(r)
	cr.FieldsPerRecord = -1
	var skipped []Skipped
	for {
		rec, err := cr.Read()
		if err == io.EOF {
			return skipped, nil
		}
		if err != nil {
			return skipped, fmt.Errorf("read members: %w", err)
		}
		line, _ := cr.FieldPos(0)
		if len(rec) < 2 || rec[1] == "" {
			skipped = append(skipped, Skipped{Line: line, Reason: "no email"})
			continue
		}
		m := store.Member{ID: uuid.NewString(), Name: rec[0], Email: rec[1]}
		if err := s.Insert(ctx, m); err != nil {
			return skipped, fmt.Errorf("line %d: %w", line, err)
		}
	}
}
EOF
cat > cmd/members/main.go <<'EOF'
// Command members manages the club's member list.
package main

import (
	"context"
	"fmt"
	"os"

	"example.com/members/internal/importer"
	"example.com/members/internal/store"
)

func main() {
	ctx := context.Background()
	s := store.New()
	switch {
	case len(os.Args) == 4 && os.Args[1] == "add":
		m := store.Member{ID: store.NewID(), Name: os.Args[2], Email: os.Args[3]}
		if err := s.Insert(ctx, m); err != nil {
			fmt.Fprintf(os.Stderr, "members: %v\n", err)
			os.Exit(1)
		}
	case len(os.Args) == 3 && os.Args[1] == "import":
		f, err := os.Open(os.Args[2])
		if err != nil {
			fmt.Fprintf(os.Stderr, "members: %v\n", err)
			os.Exit(1)
		}
		skipped, err := importer.CSV(ctx, f, s)
		f.Close()
		for _, sk := range skipped {
			fmt.Fprintf(os.Stderr, "members: line %d skipped: %s\n", sk.Line, sk.Reason)
		}
		if err != nil {
			fmt.Fprintf(os.Stderr, "members: %v\n", err)
			os.Exit(1)
		}
	default:
		fmt.Fprintln(os.Stderr, "usage: members add <name> <email> | members import <file.csv>")
		os.Exit(2)
	}
}
EOF
g add -A
g commit -q -m "Import members from a CSV export"
