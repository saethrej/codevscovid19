import { Middleware, MiddlewareInterface } from 'socket-controllers'
import { Socket } from 'socket.io'

//TODO: Implement Authentication Mechanism
@Middleware()
export class AuthenticationMiddleware implements MiddlewareInterface {
  use(socket: Socket, next: (err?: any) => any) {
    // console.log(socket.id)
    //if (!this.checkAuthentication(socket.handshake.query.token))
    //some authentication mechanism
    return next() // new Error('failed authentication'))
  }
}
