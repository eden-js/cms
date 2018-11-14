
// import dependencies
const Model = require('model');

// import helpers
const BlockHelper = helper('cms/block');

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
  async sanitise (req) {
    // return placement
    return {
      'id'         : this.get('_id') ? this.get('_id').toString() : null,
      'type'       : this.get('type'),
      'name'       : this.get('name'),
      'render'     : req ? (await Promise.all((this.get('blocks') || []).map(async (block) => {
        // get from register
        let registered = BlockHelper.blocks().find((b) => b.type === block.type);

        // check registered
        if (!registered) return null;

        // get data
        let data = await registered.render(req, block);

        // set uuid
        data.uuid = block.uuid;

        // return render
        return data;
      }))).filter((b) => b) : null,
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
