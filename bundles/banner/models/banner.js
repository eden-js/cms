
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Banner extends Model {
  /**
   * construct banner model
   */
  constructor () {
    // run super
    super(...arguments);
  }

  /**
   * sanitises banner
   *
   * @return {Promise}
   */
  async sanitise () {
    // return banner
    return {
      'id'      : this.get('_id') ? this.get('_id').toString() : null,
      'title'   : this.get('title'),
      'image'   : await this.get('image') ? await (await this.get('image')).sanitise() : null,
      'content' : this.get('content'),
    };
  }
}

/**
 * export user class
 * @type {user}
 */
exports = module.exports = Banner;
