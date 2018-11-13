
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Placement extends Model {
  /**
   * construct placement model
   */
  constructor () {
    // run super
    super(...arguments);
  }

  /**
   * sanitises placement
   *
   * @return {Promise}
   */
  async sanitise () {
    // return placement
    return {
      'id'         : this.get('_id') ? this.get('_id').toString() : null,
      'type'       : this.get('type'),
      'name'       : this.get('name'),
      'blocks'     : this.get('blocks')     || [],
      'placements' : this.get('placements') || []
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Placement;
