class RgMap {

  constructor(opts) {
    riot.observable(this)
    this._options = opts
  }

  get options() {
    if (rg.isUndefined(this._options)) {
      this._options = {
        center: {
          lat: 53.806,
          lng: -1.535
        },
        zoom: 7
      }
    }

    return this._options
  }
  set checked(options) {
    this._options = options
    this.trigger('change')
  }
}
