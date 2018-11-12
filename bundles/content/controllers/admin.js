
// bind dependencies
const Controller = require('controller');

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
   * @menu  {ADMIN} CMS
   * @icon  fa fa-newspaper
   * @route {GET} /
   */
  async indexAction (req, res) {

  }
}

/**
 * export CMSAdminController controller
 *
 * @type {CMSAdminController}
 */
exports = module.exports = CMSAdminController;
