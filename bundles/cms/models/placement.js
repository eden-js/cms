
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
  constructor() {
    // run super
    super(...arguments);
  }

  /**
   * sanitises placement
   *
   * @return {Promise}
   */
  async sanitise(req) {
    // return placement
    return {
      id     : this.get('_id') ? this.get('_id').toString() : null,
      type   : this.get('type'),
      name   : this.get('name'),
      render : req ? (await Promise.all((this.get('elements') || []).map(async (block) => {
        // get from register
        const registered = BlockHelper.blocks().find(b => b.type === block.type) || BlockHelper.blocks().find(b => b.type === 'frontend.content');

        // check registered
        if (!registered) return null;

        // get data
        const data = await registered.render(req, block);

        // set uuid
        data.uuid = block.uuid;

        // return render
        return data;
      }))).filter(b => b) : null,
      position  : this.get('position'),
      elements  : this.get('elements') || [],
      positions : this.get('positions') || [],
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Placement;
