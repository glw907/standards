# standards

A Claude Code plugin marketplace holding one plugin, `standards`: craft skills for languages and tools, review agents, and a short lifecycle for planning, executing, and closing a pass of work. Anything in it works in any repository, with no machine-specific tool or path assumed. The `kitty-headless-shot` helper needs `distrobox`.

## Install

In a Claude Code session, add the marketplace and install the plugin:

```sh
claude plugin marketplace add glw907/standards
claude plugin install standards@glw907-standards
```

A repository can load it for everyone who trusts the folder by listing it in `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "glw907-standards": {
      "source": { "source": "github", "repo": "glw907/standards" },
      "autoUpdate": true
    }
  },
  "enabledPlugins": { "standards@glw907-standards": true }
}
```

Plugin skills and agents carry the `standards:` prefix, such as `standards:diff-reviewer`.

## What is here

- `plugins/standards/skills/` holds the skills. Each `SKILL.md` stays under 500 lines.
- `plugins/standards/agents/` holds the review agents.
- `plugins/standards/bin/` holds the command-line helpers the skills call.
- `scripts/scan.sh` checks the repository for secrets and personal paths before every push and in CI.

## Contributing

Changes land by pull request. The `validate` check runs `claude plugin validate` on the plugin and the marketplace, the scan, the skill length check, and the reference check. See `THIRD-PARTY-NOTICES` for vendored skills and their licenses.

## License

MIT. See `LICENSE`.
