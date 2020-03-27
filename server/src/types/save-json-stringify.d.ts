declare module 'safe-json-stringify' {
  // fix typings of @types/safe-json-stringify
  function safeJsonStringify(
    data: object,
    transform?: (key: string, value: any) => any,
    space?: string | number
  ): string

  export = safeJsonStringify
}
