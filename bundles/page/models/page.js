
/**
 * Created by Awesome on 2/6/2016.
 */

// use strict


// import local dependencies
const Model = require('model');

/**
 * create page class
 */
class Page extends Model {
  /**
   * construct page model
   *
   * @param attrs
   * @param options
   */
  constructor() {
    // run super
    super(...arguments);

    // bind methods
    this.sanitise = this.sanitise.bind(this);
  }

  /**
   * sanitises bot
   *
   * @return {Object}
   */
  async sanitise(req) {
    // return sanitised bot
    return {
      id        : this.get('_id') ? this.get('_id').toString() : null,
      type      : this.get('type'),
      slug      : this.get('slug') || '',
      title     : this.get('title'),
      layout    : this.get('layout') || 'main',
      placement : await this.get('placement') ? await (await this.get('placement')).sanitise(req) : null,
    };
  }
}

/**
 * export page class
 *
 * @type {page}
 */
exports = module.exports = Page;
