
// create mixin
riot.mixin('loading', {
  /**
   * on init function
   */
  init() {
    // set loading
    this.__loading = new Map();

    // check loading
    this.loading = (item, way) => {
      // check way
      if (item && typeof way === 'undefined') {
        // return loading
        return !!this.__loading.get(item);
      }
      if (typeof way !== 'undefined') {
        // return loading
        this.__loading.set(item, way);

        // update view
        this.update();

        // return loading item
        return this.loading(item);
      }

      // return is loading
      return !!Array.from(this.__loading.values()).find(val => val);
    };
  },
});
