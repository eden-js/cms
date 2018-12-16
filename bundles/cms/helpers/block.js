
// require dependencies
const Helper = require('helper');

// require models
const Placement = model('placement');

/**
 * build placement helper
 */
class BlockHelper extends Helper {
  /**
   * construct placement helper
   */
  constructor() {
    // run super
    super();

    // bind methods
    this.build = this.build.bind(this);

    // run build method
    this.build();
  }

  /**
   * builds placement helper
   */
  build() {
    // build placement helper
    this.__blocks = [];
  }

  /**
   * register block
   *
   * @param  {String}   type
   * @param  {Object}   opts
   * @param  {Function} render
   * @param  {Function} save
   *
   * @return {*}
   */
  block(type, opts, render, save) {
    // check found
    const found = this.__blocks.find(block => block.type === type);

    // push block
    if (!found) {
      // check found
      this.__blocks.push({
        type,
        opts,
        save,
        render,
      });
    } else {
      // set on found
      found.type = type;
      found.opts = opts;
      found.save = save;
      found.render = render;
    }
  }

  /**
   * gets blocks
   *
   * @return {Array}
   */
  blocks() {
    // returns blocks
    return this.__blocks;
  }

  /**
   * render blocks
   *
   * @return {Array}
   */
  renderBlocks(include) {
    // map blocks
    return this.__blocks.filter((block) => {
      // check for
      if (include && block.opts.for) return block.opts.for.includes(include);

      // return true
      return true;
    }).map((block) => {
      // return block
      return {
        type : block.type,
        opts : block.opts,
      };
    });
  }

  /**
   * returns placement list
   *
   * @param  {User}    user
   * @param  {String}  type
   *
   * @return {Promise}
   */
  async render(type, user) {
    // return object
    return {
      blocks    : this.renderBlocks(),
      placement : (await Placement.findOne({
        type,
      }) || new Placement({
        type,
      })).sanitise(),
    };
  }
}

/**
 * export new BlockHelper class
 *
 * @return {BlockHelper}
 */
module.exports = new BlockHelper();
