
// create mixin
riot.mixin('block', {
  /**
   * on init function
   */
  init() {
    // set opts from parent opts
    for (const key in this.parent.opts) {
      // set key
      this.opts[key] = this.parent.opts[key];
    }
  },
});
