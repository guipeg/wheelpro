const fs = require('fs');
const path = require('path');

const ROOT = process.cwd();
const OUTPUT = path.join(ROOT, 'all-monorepo-code.txt');

const EXTENSIONS = [
  '.ts', '.tsx', '.js', '.jsx',
  '.vue', '.json', '.sql', '.graphql',
  '.yml', '.yaml'
];

const EXCLUDED_DIRS = ['node_modules', '.git', 'dist', 'coverage'];

function collectAllFiles(dir, result = []) {
  if (!fs.existsSync(dir)) return result;

  const entries = fs.readdirSync(dir);
  for (const entry of entries) {
    const fullPath = path.join(dir, entry);
    const stat = fs.statSync(fullPath);

    if (stat.isDirectory()) {
      const isExcluded = EXCLUDED_DIRS.includes(entry.toLowerCase());
      if (!isExcluded) collectAllFiles(fullPath, result);
    } else if (EXTENSIONS.includes(path.extname(entry))) {
      result.push(fullPath);
    }
  }

  return result;
}

function exportCode() {
  const files = collectAllFiles(ROOT);
  const stream = fs.createWriteStream(OUTPUT, { flags: 'w', encoding: 'utf8' });

  for (const file of files) {
    const relative = path.relative(ROOT, file);
    try {
      const content = fs.readFileSync(file, 'utf8');
      stream.write(`// ==== ${relative} ====\n`);
      stream.write(content);
      stream.write('\n\n');
    } catch (err) {
      console.error(`⚠️ Erro ao ler: ${relative}`, err.message);
    }
  }

  stream.end(() => {
    console.log(`✅ Arquivo exportado para: ${OUTPUT}`);
  });
}

exportCode();
