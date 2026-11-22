#!/usr/bin/env bash
# Builds a small static site in the run's working folder.
set -euo pipefail
mkdir -p src
cat > README.md <<'EOF'
# Harbor Rowing Club site

A static site built with Eleventy. Each page is a Markdown file in `src/`. Netlify builds the site
and deploys it on every push to `main`.
EOF
cat > package.json <<'EOF'
{
  "name": "harbor-rowing-club",
  "private": true,
  "scripts": { "build": "eleventy", "start": "eleventy --serve" },
  "devDependencies": { "@11ty/eleventy": "^3.0.0" }
}
EOF
printf '# Harbor Rowing Club\n\nWe row from the town dock, April to October.\n' > src/index.md
printf '# Membership\n\nDues are paid once a year, in March.\n' > src/membership.md
