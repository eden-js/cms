
// bind dependencies
const Controller = require('controller');

// require models
const Banner = model('banner');

// require helpers
const BlockHelper = helper('cms/block');

/**
 * build Banner controller
 *
 * @mount   /
 * @priority 50
 */
class BannerController extends Controller {
  /**
  * construct Banner controller
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
  * build Banner controller
  */
  build() {
    // register simple block
    BlockHelper.block('cms.banner', {
      for         : ['frontend', 'admin'],
      title       : 'Banner Block',
      description : 'Banner Block',
    }, async (req, block) => {
      // set data
      const data = {};

      // set other info
      data.tag = 'slider';
      data.slides = await Promise.all((await Banner.find({
        category : block.category || '',
      })).map(banner => banner.sanitise()));

      // return
      return data;
    }, async (req, block) => { });
  }
}

/**
 * export BannerController controller
 *
 * @type {BannerController}
 */
exports = module.exports = BannerController;
