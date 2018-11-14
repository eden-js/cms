
// bind dependencies
const Controller = require('controller');

// load models
const Block     = model('block');
const Dashboard = model('dashboard');

// require helpers
const BlockHelper = helper('cms/block');

/**
 * build Block controller
 *
 * @acl      admin.cms
 * @fail     next
 * @mount    /admin/cms
 * @priority 50
 */
class CMSAdminController extends Controller {
  /**
   * construct Block controller
   */
  constructor () {
    // run super
    super();

    // register simple block
    BlockHelper.block('frotend.content', {
      'for'         : ['frontend'],
      'title'       : 'WYSIWYG Area',
      'description' : 'Lets you add HTML to a block'
    }, async (req, block) => {
      // get notes block from db
      let blockModel = await Block.findOne({
        'uuid' : block.uuid
      }) || new Block({
        'uuid' : block.uuid,
        'type' : block.type
      });

      // return
      return {
        'tag'     : 'content',
        'class'   : blockModel.get('class') || null,
        'title'   : blockModel.get('title') || '',
        'content' : blockModel.get('content') || ''
      };
    }, async (req, block) => {
      // get notes block from db
      let blockModel = await Block.findOne({
        'uuid' : block.uuid
      }) || new Block({
        'uuid' : block.uuid,
        'type' : block.type
      });

      // set data
      blockModel.set('class',   req.body.data.class);
      blockModel.set('title',   req.body.data.title);
      blockModel.set('content', req.body.data.content);

      // save block
      await blockModel.save();
    });
  }

  /**
   * admin CMS index
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   *
   * @menu   {ADMIN} CMS
   * @icon   fa fa-newspaper
   * @route  {GET} /
   * @layout admin
   */
  async indexAction (req, res) {
    // get dashboards
    let dashboards = await Dashboard.where({
      'type' : 'admin.cms'
    }).or({
      'user.id' : req.user.get('_id').toString()
    }, {
      'public' : true
    }).find();

    // Render admin page
    res.render('admin', {
      'name'       : 'Admin CMS',
      'type'       : 'admin.cms',
      'blocks'     : BlockHelper.renderBlocks('admin'),
      'jumbotron'  : 'Manage CMS',
      'dashboards' : await Promise.all(dashboards.map(async (dashboard, i) => dashboard.sanitise(i === 0 ? req : null)))
    });
  }
}

/**
 * export CMSAdminController controller
 *
 * @type {CMSAdminController}
 */
exports = module.exports = CMSAdminController;
