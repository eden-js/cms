
// create mixin
riot.mixin('block', {
  /**
   * on init function
   */
  init() {
    // set opts from parent opts
    Object.keys(this.parent.opts).forEach((key) => {
      // set key
      this.opts[key] = this.parent.opts[key];
    });
  },
});
