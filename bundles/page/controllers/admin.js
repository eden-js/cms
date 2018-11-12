
// bind dependencies
const Grid       = require('grid');
const slug       = require('slug');
const alert      = require('alert');
const config     = require('config');
const Controller = require('controller');

// require models
const Page = model('page');

/**
 * build user pageAdminController controller
 *
 * @acl   admin.page.view
 * @fail  /
 * @mount /admin/page
 */
class pageAdminController extends Controller {
  /**
   * construct user pageAdminController controller
   */
  constructor () {
    // run super
    super ();

    // bind methods
    this.gridAction         = this.gridAction.bind(this);
    this.indexAction        = this.indexAction.bind(this);
    this.createAction       = this.createAction.bind(this);
    this.updateAction       = this.updateAction.bind(this);
    this.removeAction       = this.removeAction.bind(this);
    this.createSubmitAction = this.createSubmitAction.bind(this);
    this.updateSubmitAction = this.updateSubmitAction.bind(this);
    this.removeSubmitAction = this.removeSubmitAction.bind(this);

    // bind private methods
    this._grid = this._grid.bind(this);
  }

  /**
   * index action
   *
   * @param req
   * @param res
   *
   * @icon    fa fa-file
   * @menu    {ADMIN} pages
   * @title   page Administration
   * @route   {get} /
   * @parent  /admin/cms
   * @layout  admin
   */
  async indexAction (req, res) {
    // render grid
    res.render('page/admin', {
      'grid' : await this._grid(req).render(req)
    });
  }

  /**
   * add/edit action
   *
   * @route    {get} /create
   * @layout   admin
   * @priority 12
   */
  createAction () {
    // return update action
    return this.updateAction(...arguments);
  }

  /**
   * update action
   *
   * @param req
   * @param res
   *
   * @route   {get} /:id/update
   * @layout  admin
   */
  async updateAction (req, res) {
    // set website variable
    let page   = new Page();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      page   = await Page.findById(req.params.id);
      create = false;
    }

    // render page
    res.render('page/admin/update', {
      'item'  : await page.sanitise(),
      'title' : create ? 'Create page' : 'Update ' + page.get('_id').toString()
    });
  }

  /**
   * create submit action
   *
   * @route   {post} /create
   * @layout  admin
   */
  createSubmitAction () {
    // return update action
    return this.updateSubmitAction(...arguments);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/update
   * @layout  admin
   */
  async updateSubmitAction (req, res) {
    // set website variable
    let page   = new Page();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      page   = await Page.findById(req.params.id);
      create = false;
    }

    // update page
    page.set('page',    req.body.page);
    page.set('slug',    req.body.slug);
    page.set('title',   req.body.title);
    page.set('content', req.body.content);

    // save page
    await page.save();

    // send alert
    req.alert('success', 'Successfully ' + (create ? 'Created' : 'Updated') + ' page!');

    // render page
    res.render('page/admin/update', {
      'item'  : await page.sanitise(),
      'title' : create ? 'Create page' : 'Update ' + page.get('_id').toString()
    });
  }

  /**
   * delete action
   *
   * @param req
   * @param res
   *
   * @route   {get} /:id/remove
   * @layout  admin
   */
  async removeAction (req, res) {
    // set website variable
    let page = false;

    // check for website model
    if (req.params.id) {
      // load user
      page = await Page.findById(req.params.id);
    }

    // render page
    res.render('page/admin/remove', {
      'item'  : await page.sanitise(),
      'title' : 'Remove ' + page.get('_id').toString()
    });
  }

  /**
   * delete action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/remove
   * @title   Remove page
   * @layout  admin
   */
  async removeSubmitAction (req, res) {
    // set website variable
    let page = false;

    // check for website model
    if (req.params.id) {
      // load user
      page = await Page.findById(req.params.id);
    }

    // delete website
    await page.remove();

    // alert Removed
    req.alert ('success', 'Successfully removed ' + (page.get('_id').toString()));

    // render index
    return this.indexAction(req, res);
  }

  /**
   * user grid action
   *
   * @param req
   * @param res
   *
   * @route {post} /grid
   */
  gridAction (req, res) {
    // return post grid request
    return this._grid(req).post(req, res);
  }

  /**
   * renders grid
   *
   * @return {grid}
   */
  _grid (req) {
    // create new grid
    let pageGrid = new Grid();

    // set route
    pageGrid.route('/admin/page/grid');

    // set grid model
    pageGrid.model(Page);

    // add grid columns
    pageGrid.column('_id', {
      'title'  : 'ID',
      'width'  : '1%',
      'format' : async (col) => {
        return col ? '<a href="/admin/page/' + col.toString() + '/update">' + col.toString() + '</a>' : '<i>N/A</i>';
      }
    }).column('slug', {
      'sort'   : true,
      'title'  : 'Slug',
      'format' : async (col, row) => {
        return col ? col.toString() : '<i>N/A</i>';
      }
    }).column('title', {
      'sort'   : true,
      'title'  : 'Title',
      'format' : async (col, row) => {
        return col ? col[req.language].toString() : '<i>N/A</i>';
      }
    }).column('updated_at', {
      'sort'   : true,
      'title'  : 'Updated',
      'format' : async (col) => {
        return col.toLocaleDateString('en-GB', {
          'day'   : 'numeric',
          'month' : 'short',
          'year'  : 'numeric'
        });
      }
    }).column('created_at', {
      'sort'   : true,
      'title'  : 'Created',
      'format' : async (col) => {
        return col.toLocaleDateString('en-GB', {
          'day'   : 'numeric',
          'month' : 'short',
          'year'  : 'numeric'
        });
      }
    }).column('actions', {
      'type'   : false,
      'width'  : '1%',
      'title'  : 'Actions',
      'format' : async (col, row) => {
        return [
          '<div class="btn-group btn-group-sm" role="group">',
            '<a href="/admin/page/' + row.get('_id').toString() + '/update" class="btn btn-primary"><i class="fa fa-pencil"></i></a>',
            '<a href="/admin/page/' + row.get('_id').toString() + '/remove" class="btn btn-danger"><i class="fa fa-times"></i></a>',
          '</div>'
        ].join('');
      }
    });

    // add grid filters
    pageGrid.filter('slug', {
      'title' : 'Slug',
      'type'  : 'text',
      'query' : async (param) => {
        // another where
        pageGrid.where({
          'slug' : new RegExp(param.toString().toLowerCase(), 'i')
        });
      }
    }).filter('title', {
      'title' : 'Title',
      'type'  : 'text',
      'query' : async (param) => {
        // another where
        pageGrid.where({
          ['title.' + req.language] : new RegExp(param.toString().toLowerCase(), 'i')
        });
      }
    }).filter('created_at', {
      'title' : 'Created',
      'type'  : 'date',
      'query' : async (param) => {
        // set extend
        pageGrid.gte('created_at', new Date(param.start));
        pageGrid.lte('created_at', new Date(param.end));
      }
    }).filter('updated_at', {
      'title' : 'Updated',
      'type'  : 'date',
      'query' : async (param) => {
        // set extend
        pageGrid.gte('updated_at', new Date(param.start));
        pageGrid.lte('updated_at', new Date(param.end));
      }
    });

    // set default sort order
    pageGrid.sort('created_at', 1);

    // return grid
    return pageGrid;
  }
}

/**
 * export pageAdminController controller
 *
 * @type {ADMIN}
 */
exports = module.exports = pageAdminController;
