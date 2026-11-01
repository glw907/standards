// Fail when a skill reference over 100 lines does not open with a contents list, or when a
// reference sits more than one level below its SKILL.md (Anthropic's skill authoring guidance).
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../plugins', import.meta.url));
let failed = false;

function walk(dir) {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? walk(path) : [path];
  });
}

for (const file of walk(root)) {
  const rel = file.slice(root.length + 1);
  const parts = rel.split('/');
  const skillAt = parts.indexOf('skills');
  if (skillAt === -1 || parts.includes('assets') || parts[parts.length - 1] === 'SKILL.md' || !file.endsWith('.md')) continue;
  const depth = parts.length - (skillAt + 2);
  const lines = readFileSync(file, 'utf8').split('\n');
  if (lines.length > 100 && !lines.slice(0, 25).some((l) => /contents|^\s*[-*]\s+\[.*\]\(#/i.test(l))) {
    console.error(`check-references: ${rel} has ${lines.length} lines and no contents list near the top`);
    failed = true;
  }
  if (parts[skillAt + 2] && depth > 2) {
    console.error(`check-references: ${rel} is nested more than one level below its skill`);
    failed = true;
  }
}

process.exit(failed ? 1 : 0);
