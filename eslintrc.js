module.exports = {
  extends: 'google',
  env: {
    jquery: true,
    browser: true,
    node: true
  },
  globals: {
    DS: true,
    '_': true,
    Highcharts: true,
    MQ: true
  },
  rules: {
    'max-len': [2, {
      code: 150,
      tabWidth: 2,
      ignoreComments: true,
      ignoreUrls: true
    }],
    'require-jsdoc': 'off',
    'one-var': 'off',
    'spaced-comment': 'off'
  }
}
