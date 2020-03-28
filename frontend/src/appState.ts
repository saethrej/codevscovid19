import { observable, action } from 'mobx'
import bind from 'bind-decorator'
import { LatLngTuple } from 'leaflet'
import React from 'react'

class AppState {
  @observable
  position: LatLngTuple = [0, 0]
  @observable
  mapContainerRef = React.createRef<HTMLDivElement>()
  @observable
  IDLocMap: Map<LatLngTuple, Number> = new Map()

  constructor() {
    this.IDLocMap.set([47.357166, 8.50538], 0)
    this.IDLocMap.set([47.362026, 8.501828], 1)
  }

  @bind
  @action
  async setLatLng() {
    const geo = navigator.geolocation
    if (geo) {
      await geo.getCurrentPosition(this.setPosition)
    }
  }

  @bind
  @action
  setPosition(position: Position) {
    this.position = [position.coords.latitude, position.coords.longitude]
    const req = new XMLHttpRequest()
    const pos = this.position
    let mapHeight: number = -1
    let mapWidth: number = -1
    if (this.mapContainerRef.current) {
      const mapRef = this.mapContainerRef.current
      mapHeight = mapRef.clientHeight
      mapWidth = mapRef.clientWidth
    }
    const msg = JSON.stringify({
      position: pos,
      height: mapHeight,
      width: mapWidth
    })
    req.open('POST', 'http://localhost:8000')
    req.setRequestHeader('Content-type', 'application/json')
    req.onreadystatechange = (_event: Event) => {
      if (req.readyState === 4 && req.status === 200) {
        appState.parseResponse(req)
      }
    }
    req.send(msg)
  }

  @bind
  @action
  parseResponse(req: XMLHttpRequest) {
    const answer = JSON.parse(req.response)
    for (let i = 0; i < answer.stores.length; i++) {
      const id: Number = answer[i].store_id
      const ltlg: LatLngTuple = [answer[i].latitude, answer[i].longitude]
      this.IDLocMap.set(ltlg, id)
    }
  }
}

export const appState = new AppState()
