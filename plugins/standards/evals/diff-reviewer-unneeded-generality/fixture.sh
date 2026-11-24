#!/usr/bin/env bash
# Builds a small Go repo whose feature branch adds reminder sending and a choice of store.
set -euo pipefail
g() { git -c user.name=Eval -c user.email=eval@example.com "$@"; }

git init -q -b main
mkdir -p cmd/remind internal/reminder
cat > go.mod <<'EOF'
module example.com/remind

go 1.24
EOF
cat > internal/reminder/reminder.go <<'EOF'
// Package reminder holds the reminders a club sends its members.
package reminder

import "time"

// Reminder is one message due to one member.
type Reminder struct {
	Email string    `json:"email"`
	Text  string    `json:"text"`
	Due   time.Time `json:"due"`
}

// Due returns the reminders in rs whose due time is at or before now.
func Due(rs []Reminder, now time.Time) []Reminder {
	var out []Reminder
	for _, r := range rs {
		if !r.Due.After(now) {
			out = append(out, r)
		}
	}
	return out
}
EOF
cat > cmd/remind/main.go <<'EOF'
// Command remind sends a club's due reminders.
package main

func main() {}
EOF
g add -A
g commit -q -m "Start the remind command"

git checkout -q -b feature
cat > internal/reminder/store.go <<'EOF'
package reminder

import (
	"encoding/json"
	"errors"
	"io/fs"
	"os"
)

// Store keeps the club's reminders.
type Store interface {
	Load() ([]Reminder, error)
}

// FileStore keeps reminders in a JSON file.
type FileStore struct {
	Path string
}

// Load reads the reminders from the file. A missing file holds no reminders.
func (s FileStore) Load() ([]Reminder, error) {
	b, err := os.ReadFile(s.Path)
	if errors.Is(err, fs.ErrNotExist) {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}
	var rs []Reminder
	if err := json.Unmarshal(b, &rs); err != nil {
		return nil, err
	}
	return rs, nil
}

// MemStore keeps reminders in memory, for a dry run.
type MemStore struct {
	Reminders []Reminder
}

// Load returns the reminders held in memory.
func (s *MemStore) Load() ([]Reminder, error) {
	return s.Reminders, nil
}
EOF
cat > internal/reminder/notify.go <<'EOF'
package reminder

import (
	"fmt"
	"net/smtp"
)

// Notifier sends one reminder to its member.
type Notifier interface {
	Notify(r Reminder) error
}

// EmailNotifier sends reminders through an SMTP relay.
type EmailNotifier struct {
	addr    string
	from    string
	retries int
}

// Option configures an EmailNotifier.
type Option func(*EmailNotifier)

// WithRetries sets how many times a failed send is retried.
func WithRetries(n int) Option {
	return func(e *EmailNotifier) { e.retries = n }
}

// NewEmailNotifier returns a notifier that sends from the given address through the relay at addr.
func NewEmailNotifier(addr, from string, opts ...Option) *EmailNotifier {
	e := &EmailNotifier{addr: addr, from: from}
	for _, o := range opts {
		o(e)
	}
	return e
}

// Notify emails r to its member.
func (e *EmailNotifier) Notify(r Reminder) error {
	msg := fmt.Sprintf("From: %s\r\nTo: %s\r\nSubject: Reminder\r\n\r\n%s\r\n", e.from, r.Email, r.Text)
	if err := smtp.SendMail(e.addr, nil, e.from, []string{r.Email}, []byte(msg)); err != nil {
		return fmt.Errorf("send to %s: %w", r.Email, err)
	}
	return nil
}
EOF
cat > cmd/remind/main.go <<'EOF'
// Command remind sends a club's due reminders.
package main

import (
	"flag"
	"fmt"
	"os"
	"time"

	"example.com/remind/internal/reminder"
)

func main() {
	storeKind := flag.String("store", "file", "where reminders are kept: file or memory")
	path := flag.String("path", "reminders.json", "the reminders file, for -store file")
	relay := flag.String("relay", "localhost:25", "the SMTP relay")
	from := flag.String("from", "club@example.com", "the sender address")
	flag.Parse()

	var store reminder.Store
	switch *storeKind {
	case "file":
		store = reminder.FileStore{Path: *path}
	case "memory":
		store = &reminder.MemStore{}
	default:
		fmt.Fprintf(os.Stderr, "remind: unknown store %q\n", *storeKind)
		os.Exit(2)
	}

	rs, err := store.Load()
	if err != nil {
		fmt.Fprintf(os.Stderr, "remind: %v\n", err)
		os.Exit(1)
	}

	var n reminder.Notifier = reminder.NewEmailNotifier(*relay, *from)
	failed := 0
	for _, r := range reminder.Due(rs, time.Now()) {
		if err := n.Notify(r); err != nil {
			fmt.Fprintf(os.Stderr, "remind: %v\n", err)
			failed++
		}
	}
	if failed > 0 {
		os.Exit(1)
	}
}
EOF
g add -A
g commit -q -m "Send due reminders by email from a chosen store"
