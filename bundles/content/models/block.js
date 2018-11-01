
/**
 * Created by Awesome on 2/6/2016.
 */

// use strict
'use strict';

// import local dependencies
const Model = require('model');

/**
 * create Block class
 */
class Block extends Model {
  /**
   * construct Block model
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
      'id'        : this.get('_id') ? this.get('_id').toString() : null,
      'type'      : this.get('type'),
      'title'     : this.get('title')     || {},
      'content'   : this.get('content')   || {},
      'placement' : this.get('placement') || ''
    };
  }
}

/**
 * export Block class
 *
 * @type {Block}
 */
exports = module.exports = Block;
