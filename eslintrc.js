module.exports = {
  extends: ['eslint:recommended', 'google'],
  ecmaVersion: 6,
  env: {
    jquery: true,
    browser: true,
    node: true
  },
  globals: {
    DS: true,
    _: true,
    Highcharts: true,
    MQ: true,
    Handlebars: true
  },
  rules: {
    'max-len': [
      2,
      {
        code: 80,
        tabWidth: 2,
        ignoreComments: true,
        ignoreUrls: true
      }
    ],
    'require-jsdoc': 'off',
    'one-var': 'off',
    'spaced-comment': 'off',
    'no-var': 'off',
    'comma-dangle': 'off'
  }
};
