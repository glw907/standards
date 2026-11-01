// Fail unless `claude plugin validate` reports no error and only the missing-version warning.
// The plugin sets no `version` on purpose: a pinned version hides updates from auto-update.
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('..', import.meta.url));
const targets = ['plugins/standards', '.'];
let failed = false;

for (const target of targets) {
  const run = spawnSync('claude', ['plugin', 'validate', target, '--json'], { cwd: root, encoding: 'utf8' });
  let report;
  try {
    report = JSON.parse(run.stdout);
  } catch {
    console.error(`validate-warnings: ${target} gave no JSON`, run.stderr);
    failed = true;
    continue;
  }
  const { errors, warnings } = report.manifest;
  const unexpected = warnings.filter((w) => !/version$/.test(w.path));
  if (!report.success || errors.length > 0 || unexpected.length > 0) {
    failed = true;
    console.error(`validate-warnings: ${target}`, JSON.stringify({ errors, unexpected }, null, 2));
  }
}

process.exit(failed ? 1 : 0);
