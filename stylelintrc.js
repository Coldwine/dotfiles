const path = require('path');
const nodeModules = path.join(process.env.NPM_CONFIG_PREFIX, 'lib', 'node_modules');

module.exports = {
  extends: path.join(nodeModules, 'stylelint-config-standard'),
  plugins: [
    path.join(nodeModules, 'stylelint-selector-bem-pattern'),
    path.join(nodeModules, 'stylelint-scss')
  ],
  rules: {
    'plugin/selector-bem-pattern': {
      preset: 'bem'
    },
    'scss/selector-no-redundant-nesting-selector': true,
    'at-rule-empty-line-before': 'always',
    'declaration-empty-line-before': 'never'
  }
};
