import os from 'os'
import { Controller, Get, NotAcceptableError, Param } from 'routing-controllers'

@Controller('/info')
export class InfoController {
  @Get('/_info/:param')
  async getInfo(@Param('param') param: string) {
    return {
      param: param,
      ok: true,
      hostname: os.hostname(),
      load: os.loadavg(),
      freemem: os.freemem()
    }
  }

  @Get('/_throwError')
  async throwError() {
    let a: any = {}
    a.asdf()
  }

  @Get('/_throw')
  async throw() {
    throw new NotAcceptableError('Bad bad')
  }

  @Get('/_throwstring')
  async throwString() {
    // eslint-disable-next-line @typescript-eslint/no-throw-literal
    throw 'evil string throwing'
  }
}
