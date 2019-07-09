
// import dependencies
const Model = require('model');

/**
 * create user class
 */
class Banner extends Model {
  /**
   * sanitises banner
   *
   * @return {Promise}
   */
  async sanitise() {
    // return banner
    return {
      id       : this.get('_id') ? this.get('_id').toString() : null,
      title    : this.get('title'),
      class    : this.get('class'),
      image    : await this.get('image') ? await (await this.get('image')).sanitise() : null,
      content  : this.get('content'),
      category : this.get('category'),
    };
  }
}

/**
 * export user class
 * @type {user}
 */
module.exports = Banner;
