
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
  constructor() {
    // run super
    super();

    // register simple block
    BlockHelper.block('frontend.content', {
      for         : ['frontend', 'admin'],
      title       : 'WYSIWYG Area',
      description : 'Lets you add HTML to a block',
    }, async (req, block) => {
      // get notes block from db
      const blockModel = await Block.findOne({
        uuid : block.uuid,
      }) || new Block({
        uuid : block.uuid,
        type : block.type,
      });

      // return
      return {
        tag     : 'content',
        content : blockModel.get('content') || '',
      };
    }, async (req, block) => {
      // get notes block from db
      const blockModel = await Block.findOne({
        uuid : block.uuid,
      }) || new Block({
        uuid : block.uuid,
        type : block.type,
      });

      // set data
      blockModel.set('content', req.body.data.content);

      // save block
      await blockModel.save(req.user);
    });

    // register simple block
    BlockHelper.block('structure.container', {
      for         : ['frontend', 'admin'],
      title       : 'Container Element',
      categories  : ['structure'],
      description : 'Creates container structure',
    }, async (req, block) => {
      // set tag
      block.tag = 'container';

      // return
      return block;
    }, async (req, block) => { });

    // register simple block
    BlockHelper.block('structure.row', {
      for         : ['frontend', 'admin'],
      title       : 'Row Element',
      categories  : ['structure'],
      description : 'Creates row structure',
    }, async (req, block) => {
      // set tag
      block.tag = 'row';

      // return
      return block;
    }, async (req, block) => { });

    // register simple block
    BlockHelper.block('structure.div', {
      for         : ['frontend', 'admin'],
      title       : 'Div Element',
      categories  : ['structure'],
      description : 'Creates div structure',
    }, async (req, block) => {
      // set tag
      block.tag = 'div';

      // return
      return block;
    }, async (req, block) => { });

    // register simple block
    BlockHelper.block('structure.navbar', {
      for         : ['frontend', 'admin'],
      title       : 'Navbar Element',
      categories  : ['structure'],
      description : 'Creates navbar structure',
    }, async (req, block) => {
      // set tag
      block.tag = 'navbar';

      // return
      return block;
    }, async (req, block) => { });
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
  async indexAction(req, res) {
    // get dashboards
    const dashboards = await Dashboard.where({
      type : 'admin.cms',
    }).or({
      'user.id' : req.user.get('_id').toString(),
    }, {
      public : true,
    }).find();

    // Render admin page
    res.render('admin', {
      name       : 'Admin CMS',
      type       : 'admin.cms',
      blocks     : BlockHelper.renderBlocks('admin'),
      jumbotron  : 'Manage CMS',
      dashboards : await Promise.all(dashboards.map(async (dashboard, i) => {
        // return sanitised dashboard
        return dashboard.sanitise(i === 0 ? req : null);
      })),
    });
  }
}

/**
 * export CMSAdminController controller
 *
 * @type {CMSAdminController}
 */
exports = module.exports = CMSAdminController;
