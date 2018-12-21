
// create mixin
riot.mixin('block', {
  /**
   * on init function
   */
  'init' : function () {
    // set opts from parent opts
    for (let key in this.parent.opts) {
      // set key
      this.opts[key] = this.parent.opts[key];
    }
  }
});
