
/**
 * Created by Awesome on 2/6/2016.
 */

// use strict
'use strict';

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
  constructor () {
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
  async sanitise () {
    // return sanitised bot
    return {
      'id'      : this.get('_id') ? this.get('_id').toString() : null,
      'slug'    : this.get('slug') || '',
      'title'   : this.get('title'),
      'content' : this.get('content') || {},
    };
  }
}

/**
 * export page class
 *
 * @type {page}
 */
exports = module.exports = Page;
