
// bind dependencies
const Controller = require('controller');

// require models
const Block  = model('block');
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
  constructor () {
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
  build () {

    // register simple block
    BlockHelper.block('cms.banner', {
      'for'         : ['frontend', 'admin'],
      'title'       : 'Banner Block',
      'description' : 'Banner Block'
    }, async (req, block) => {
      // get notes block from db
      let blockModel = await Block.findOne({
       'uuid' : block.uuid
      }) || new Block({
       'uuid' : block.uuid,
       'type' : block.type
      });

      // set data
      let data = {};

      // set other info
      data.tag    = 'slider';
      data.show   = blockModel.get('show') || {};
      data.slides = await Promise.all((await Banner.find({
        'category' : blockModel.get('category') || ''
      })).map((banner) => banner.sanitise()));
      data.class    = blockModel.get('class') || 'col';
      data.title    = blockModel.get('title') || '';
      data.interval = blockModel.get('interval')  || 2000;
      data.category = blockModel.get('category')  || '';

      // return
      return data;
    }, async (req, block) => {
      // get notes block from db
      let blockModel = await Block.findOne({
       'uuid' : block.uuid
      }) || new Block({
       'uuid' : block.uuid,
       'type' : block.type
      });

      // set data
      blockModel.set('class',    req.body.data.class);
      blockModel.set('title',    req.body.data.title);
      blockModel.set('interval', parseInt(req.body.data.interval));
      blockModel.set('category', req.body.data.category);

      // set show
      blockModel.set('show', {
        'buttons'    : !!(req.body.data.show || {}).buttons,
        'caption'    : !!(req.body.data.show || {}).caption,
        'indicators' : !!(req.body.data.show || {}).indicators,
        'background' : !!(req.body.data.show || {}).background
      });

      // save block
      await blockModel.save();
    });

  }
}

/**
 * export BannerController controller
 *
 * @type {BannerController}
 */
exports = module.exports = BannerController;
