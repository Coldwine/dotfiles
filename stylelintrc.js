const
  path = require('path'),
  nodeModules = path.join(process.env.NPM_CONFIG_PREFIX, 'lib', 'node_modules');

module.exports = {
  extends: path.join(nodeModules, 'stylelint-config-standard'),
  defaultSeverity: 'warning',
  plugins: [
    path.join(nodeModules, 'stylelint-selector-bem-pattern'),
    path.join(nodeModules, 'stylelint-scss')
  ],
  rules: {
    'plugin/selector-bem-pattern': {
      preset: 'bem'
    },
    'at-rule-empty-line-before': ['always', {
      except: [
        'blockless-after-same-name-blockless',
        'first-nested',
      ],
      ignore: [
        'after-comment',
      ],
      ignoreAtRules: [
        'include',
        'extend',
      ],
    }],
    'no-invalid-double-slash-comments': null,
    'number-leading-zero': 'never',
    'scss/at-else-closing-brace-newline-after': 'always-last-in-chain',
    'scss/at-else-closing-brace-space-after': 'always-intermediate',
    'scss/at-else-empty-line-before': 'never',
    'scss/at-extend-no-missing-placeholder': true,                                  // http://8gramgorilla.com/mastering-sass-extends-and-placeholders
    // 'scss/at-function-pattern': /foo-.+/,                                        // Do we want a specific prefix for scss-functions in a project? Replace 'foo-' with whatever it should be and uncomment the line.
    'scss/at-if-closing-brace-newline-after': 'always-last-in-chain',
    'scss/at-if-closing-brace-space-after': 'always-intermediate',
    'scss/at-import-no-partial-leading-underscore': true,
    'scss/at-import-partial-extension-blacklist': [ /scss/ ],
    'scss/at-mixin-argumentless-call-parentheses': 'always',
    // 'scss/at-mixin-pattern': /foo-.+/,                                           // Do we want a specific prefix for scss-mixins in a project? Replace 'foo-' with whatever it should be and uncomment the line.
    'scss/dollar-variable-colon-newline-after': 'always-multi-line',
    'scss/dollar-variable-colon-space-after': 'always-single-line',
    'scss/dollar-variable-colon-space-before': 'never',
    'scss/dollar-variable-empty-line-before': ['always', {
      except: [
        'first-nested',
        'after-comment',
        'after-dollar-variable',
      ],
      ignore: [
        'inside-single-line-block',
      ],
    }],
    'scss/dollar-variable-no-missing-interpolation': true,
    // 'scss/dollar-variable-pattern': /foo-.+/,                                    // Do we want a specific prefix for scss-variables in a project? Replace 'foo-' with whatever it should be and uncomment the line.
    // 'scss/percent-placeholder-pattern': /^foo-[a-z]+$/                           // Do we want a specific prefix for scss-%-placeholders in a project? Replace 'foo-' with whatever it should be and uncomment the line.
    'scss/double-slash-comment-empty-line-before': ['always', {
      except: [
        'first-nested',
      ],
      ignore: [
        'between-comments',
        'stylelint-commands',
      ],
    }],
    'scss/double-slash-comment-whitespace-inside': 'always',
    'scss/operator-no-newline-after': true,
    'scss/operator-no-newline-before': true,
    'scss/operator-no-unspaced': true,
    'scss/partial-no-import': true,
    'scss/selector-no-redundant-nesting-selector': true,
  }
};

