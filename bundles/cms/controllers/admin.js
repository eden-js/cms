
// bind dependencies
const Controller = require('controller');

// load models
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
      'blocks'     : BlockHelper.renderBlocks(),
      'jumbotron'  : 'Manage CMS',
      'dashboards' : await Promise.all(dashboards.map(async (dashboard) => dashboard.sanitise()))
    });
  }
}

/**
 * export CMSAdminController controller
 *
 * @type {CMSAdminController}
 */
exports = module.exports = CMSAdminController;
