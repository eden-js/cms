
// bind dependencies
const Controller = require('controller');

// require helpers
const DashboardHelper = helper('dashboard');

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
    // Render admin page
    res.render('admin', {
      'name'      : 'Admin CMS',
      'type'      : 'admin.cms',
      'jumbotron' : 'CMS Dashboard',
      'dashboard' : await DashboardHelper.render('admin.cms', req.user)
    });
  }
}

/**
 * export CMSAdminController controller
 *
 * @type {CMSAdminController}
 */
exports = module.exports = CMSAdminController;
