
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Block extends Model {
  /**
   * sanitises placement
   *
   * @return {Promise}
   */
  async sanitise() {
    // return placement
    return {
      id         : this.get('_id') ? this.get('_id').toString() : null,
      type       : this.get('type'),
      blocks     : this.get('blocks'),
      placements : this.get('placements'),
    };
  }
}

/**
 * export user class
 * @type {user}
 */
module.exports = Block;
