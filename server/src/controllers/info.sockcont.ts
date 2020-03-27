import {
  SocketController,
  OnConnect,
  OnDisconnect,
  OnMessage,
  SocketId,
  ConnectedSocket,
  SocketIO,
  MessageBody
} from 'socket-controllers'
import { Socket } from 'socket.io'
import { logger } from '../logger'
import sIO from 'socket.io'
import _ from 'lodash'

//prefix for namespace containing both sides
const rtcPrefix = 'rtc_'

@SocketController()
export class MessageController {
  // queus for waiting instances
  @OnConnect()
  async connection(
    @ConnectedSocket() socket: Socket,
    @SocketIO() socketIO: sIO.Server
  ) {
  }

  
  @OnDisconnect()
  async onDisconnect(
    @ConnectedSocket() socket: Socket,
    @SocketIO() io: SocketIO.Server
  ) {

  }
    
}
