
// import { rules as standardRules } from 'eslint-config-standard/eslintrc.json'
const standardRules = require('eslint-config-standard/eslintrc.json').rules

const equivalents = [
  'brace-style',
  'no-array-constructor',
  'no-throw-literal',
  'no-unused-expressions',
  'no-useless-constructor',
  'quotes'
]

function fromEntries (iterable) {
  return [...iterable].reduce((obj, [key, val]) => {
    obj[key] = val
    return obj
  }, {})
}


module.exports = {
  "extends": [
    // "standard-with-typescript",
    // 'eslint-config-standard',
    "prettier/@typescript-eslint", // Uses eslint-config-prettier to disable ESLint rules from @typescript-eslint/eslint-plugin that would conflict with prettier
    "plugin:prettier/recommended" // Enables eslint-plugin-prettier and eslint-config-prettier. This will display prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
  ],
  plugins: ['@typescript-eslint', "prettier"],
  "parserOptions": {
      "project": "./tsconfig.json",
      "sourceType": "module",
  },
  env: {
    es6: true
  },
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      parser: '@typescript-eslint/parser',
      rules: {
        // TypeScript has this functionality by default:
        'no-undef': 'off',

        // Incompatible with TypeScript function overloads:
        'no-duplicate-class-members': 'off',

        // Rules replaced by @typescript-eslint versions:
        ...fromEntries(equivalents.map((name) => [name, 'off'])),
        camelcase: 'off',
        'no-use-before-define': 'off',
        '@typescript-eslint/no-unused-vars': ['error', { varsIgnorePattern: "_.*" , argsIgnorePattern: "_.*", markTSParameterPropertyAsUsed: true }],

        // @typescript-eslint versions of Standard.js rules:
        ...fromEntries(equivalents.map((name) => [`@typescript-eslint/${name}`, standardRules[name]])),
        '@typescript-eslint/no-use-before-define': ['error', {
          functions: false,
          classes: false,
          enums: false,
          variables: false,
          typedefs: false // Only the TypeScript rule has this option.
        }],

        // Rules exclusive to Standard TypeScript:
        '@typescript-eslint/adjacent-overload-signatures': 'error',
        '@typescript-eslint/array-type': ['error', { default: 'array-simple' }],
        '@typescript-eslint/camelcase': ['error', { properties: 'never', genericType: 'always' }],
        '@typescript-eslint/consistent-type-assertions': [
          'error',
          {
            assertionStyle: 'as',
            objectLiteralTypeAssertions: 'never'
          }
        ],
        '@typescript-eslint/consistent-type-definitions': ['error', 'interface'],
        '@typescript-eslint/default-param-last': 'error',
        '@typescript-eslint/explicit-function-return-type': ['off', {
          allowExpressions: true,
          allowHigherOrderFunctions: true,
          allowTypedFunctionExpressions: true,
          allowDirectConstAssertionInArrowFunctions: true
        }],
        '@typescript-eslint/member-delimiter-style': [
          'error',
          {
            multiline: { delimiter: 'none' },
            singleline: { delimiter: 'comma', requireLast: false }
          }
        ],
        '@typescript-eslint/no-dynamic-delete': 'error',
        '@typescript-eslint/no-empty-function': ['error', {
          allow: [
            'protected-constructors',
            'private-constructors'
          ]
        }],
        '@typescript-eslint/no-empty-interface': 'error',
        '@typescript-eslint/no-extra-non-null-assertion': 'error',
        '@typescript-eslint/no-extraneous-class': ['error', { allowWithDecorator: true }],
        '@typescript-eslint/no-floating-promises': 'error',
        '@typescript-eslint/no-for-in-array': 'error',
        '@typescript-eslint/no-implied-eval': 'error',
        '@typescript-eslint/no-misused-new': 'error',
        '@typescript-eslint/no-misused-promises': 'error',
        '@typescript-eslint/no-namespace': 'error',
        '@typescript-eslint/no-non-null-assertion': 'error',
        '@typescript-eslint/no-this-alias': ['error', { allowDestructuring: true }],
        '@typescript-eslint/no-unnecessary-type-assertion': 'error',
        '@typescript-eslint/no-var-requires': 'error',
        '@typescript-eslint/prefer-function-type': 'error',
        '@typescript-eslint/prefer-nullish-coalescing': ['error', { ignoreConditionalTests: false, ignoreMixedLogicalExpressions: false }],
        '@typescript-eslint/prefer-optional-chain': 'error',
        '@typescript-eslint/prefer-readonly': 'error',
        '@typescript-eslint/promise-function-async': 'error',
        '@typescript-eslint/require-array-sort-compare': 'error',
        '@typescript-eslint/require-await': 'off',
        '@typescript-eslint/restrict-plus-operands': ['error', { checkCompoundAssignments: true }],
        '@typescript-eslint/restrict-template-expressions': ['error', {allowNumber: true}],
        '@typescript-eslint/strict-boolean-expressions': ['error', {allowSafe: true, allowNullable:true}],
        '@typescript-eslint/triple-slash-reference': ['error', { lib: 'never', path: 'never', types: 'never' }],
        '@typescript-eslint/type-annotation-spacing': 'error'
      }
    }
  ]
}