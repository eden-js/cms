
// bind dependencies
const Grid       = require('grid');
const Controller = require('controller');

// require models
const Page      = model('page');
const Block     = model('block');
const Placement = model('placement');

// bind helpers
const syncHelper  = helper('sync');
const blockHelper = helper('cms/block');

/**
 * build user PageAdminController controller
 *
 * @acl   admin.page.view
 * @fail  /
 * @mount /admin/page
 */
class PageAdminController extends Controller {
  /**
   * construct user PageAdminController controller
   */
  constructor() {
    // run super
    super();

    // bind methods
    this.gridAction = this.gridAction.bind(this);
    this.indexAction = this.indexAction.bind(this);
    this.createAction = this.createAction.bind(this);
    this.updateAction = this.updateAction.bind(this);
    this.removeAction = this.removeAction.bind(this);
    this.createSubmitAction = this.createSubmitAction.bind(this);
    this.updateSubmitAction = this.updateSubmitAction.bind(this);
    this.removeSubmitAction = this.removeSubmitAction.bind(this);

    // bind private methods
    this._grid = this._grid.bind(this);

    // register simple block
    blockHelper.block('page.cms.pages', {
      acl         : ['admin.cms'],
      for         : ['admin'],
      title       : 'Pages Grid',
      description : 'Shows grid of recent pages',
    }, async (req, block) => {
      // get notes block from db
      const blockModel = await Block.findOne({
        uuid : block.uuid,
      }) || new Block({
        uuid : block.uuid,
        type : block.type,
      });

      // create new req
      const fauxReq = {
        query : blockModel.get('state') || {},
      };

      // return
      return {
        tag   : 'grid',
        name  : 'Pages',
        grid  : await this._grid(req).render(fauxReq),
        class : blockModel.get('class') || null,
        title : blockModel.get('title') || '',
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
      blockModel.set('class', req.body.data.class);
      blockModel.set('state', req.body.data.state);
      blockModel.set('title', req.body.data.title);

      // save block
      await blockModel.save(req.user);
    });
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.listen.page
   * @return {Async}
   */
  async listenAction(id, uuid, opts) {
    // join room
    opts.socket.join(`page.${id}`);

    // add to room
    return await syncHelper.addListener(await Page.findById(id), {
      user      : opts.user,
      atomic    : true,
      listenID  : uuid,
      sessionID : opts.sessionID,
    });
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.deafen.page
   * @return {Async}
   */
  async liveDeafenAction(id, uuid, opts) {
    // join room
    opts.socket.leave(`page.${id}`);

    // add to room
    return await syncHelper.removeListener(await Page.findById(id), {
      user      : opts.user,
      atomic    : true,
      listenID  : uuid,
      sessionID : opts.sessionID,
    });
  }

  /**
   * add/edit action
   *
   * @route    {get} /:id/view
   * @layout   admin
   * @priority 12
   */
  async viewAction(req, res) {
    // set website variable
    let page = new Page();

    // check for website model
    if (req.params.id) {
      // load by id
      page = await Page.findById(req.params.id);
    }

    // res JSON
    const sanitised = await page.sanitise();

    // return JSON
    res.json({
      state   : 'success',
      result  : sanitised,
      message : 'Successfully got blocks',
    });
  }

  /**
   * index action
   *
   * @param req
   * @param res
   *
   * @icon    fa fa-file
   * @menu    {ADMIN} Pages
   * @title   page Administration
   * @route   {get} /
   * @parent  /admin/cms
   * @layout  admin
   */
  async indexAction(req, res) {
    // render grid
    res.render('page/admin', {
      grid : await this._grid(req).render(req),
    });
  }

  /**
   * add/edit action
   *
   * @route    {get} /create
   * @layout   admin
   * @priority 12
   */
  createAction(...args) {
    // return update action
    return this.updateAction(...args);
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
  async updateAction(req, res) {
    // set website variable
    let page   = new Page();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      page = await Page.findById(req.params.id);
      create = false;
    }

    // Render admin page
    res.render('page/admin/update', {
      name      : 'Admin Home',
      item      : await page.sanitise(req),
      title     : create ? 'Create page' : `Update ${page.get('_id').toString()}`,
      blocks    : blockHelper.renderBlocks('frontend'),
      jumbotron : 'Update Page',
    });
  }

  /**
   * create submit action
   *
   * @route   {post} /create
   * @layout  admin
   */
  createSubmitAction(...args) {
    // return update action
    return this.updateSubmitAction(...args);
  }


  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route  {post} /:id/update
   * @layout admin
   */
  async updateSubmitAction(req, res) {
    // set website variable
    let page   = new Page();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      page = await Page.findById(req.params.id);
      create = false;
    }

    // update page
    page.set('user', req.user);
    page.set('type', req.body.type);
    page.set('slug', req.body.slug);
    page.set('title', req.body.title);
    page.set('layout', req.body.layout);

    // check placement
    if (req.body.placement) page.set('placement', await Placement.findById(req.body.placement.id));

    // save page
    await page.save(req.user);

    // send alert
    req.alert('success', `Successfully ${create ? 'Created' : 'Updated'} page!`);

    // return JSON
    res.json({
      state   : 'success',
      result  : await page.sanitise(req),
      message : 'Successfully updated page',
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
  async removeAction(req, res) {
    // set website variable
    let page = false;

    // check for website model
    if (req.params.id) {
      // load user
      page = await Page.findById(req.params.id);
    }

    // render page
    res.render('page/admin/remove', {
      item  : await page.sanitise(req),
      title : `Remove ${page.get('_id').toString()}`,
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
  async removeSubmitAction(req, res) {
    // set website variable
    let page = false;

    // check for website model
    if (req.params.id) {
      // load user
      page = await Page.findById(req.params.id);
    }

    // alert Removed
    req.alert('success', `Successfully removed ${page.get('_id').toString()}`);

    // delete website
    await page.remove(req.user);

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
  gridAction(req, res) {
    // return post grid request
    return this._grid(req).post(req, res);
  }

  /**
   * renders grid
   *
   * @return {grid}
   */
  _grid(req) {
    // create new grid
    const pageGrid = new Grid();

    // set route
    pageGrid.route('/admin/page/grid');

    // set grid model
    pageGrid.model(Page);

    // add grid columns
    pageGrid.column('_id', {
      title  : 'ID',
      width  : '1%',
      format : async (col) => {
        return col ? `<a href="/admin/page/${col.toString()}/update">${col.toString()}</a>` : '<i>N/A</i>';
      },
    }).column('slug', {
      sort   : true,
      title  : 'Slug',
      format : async (col) => {
        return col ? col.toString() : '<i>N/A</i>';
      },
    }).column('title', {
      sort   : true,
      title  : 'Title',
      format : async (col) => {
        return col ? (col[req.language] || '').toString() : '<i>N/A</i>';
      },
    }).column('layout', {
      sort   : true,
      title  : 'Layout',
      format : async (col) => {
        return col ? col.toString() : '<i>N/A</i>';
      },
    })
      .column('updated_at', {
        sort   : true,
        title  : 'Updated',
        format : async (col) => {
          return col.toLocaleDateString('en-GB', {
            day   : 'numeric',
            month : 'short',
            year  : 'numeric',
          });
        },
      })
      .column('created_at', {
        sort   : true,
        title  : 'Created',
        format : async (col) => {
          return col.toLocaleDateString('en-GB', {
            day   : 'numeric',
            month : 'short',
            year  : 'numeric',
          });
        },
      })
      .column('actions', {
        type   : false,
        width  : '1%',
        title  : 'Actions',
        format : async (col, row) => {
          return [
            '<div class="btn-group btn-group-sm" role="group">',
            `<a href="/admin/page/${row.get('_id').toString()}/update" class="btn btn-primary"><i class="fa fa-pencil-alt"></i></a>`,
            `<a href="/admin/page/${row.get('_id').toString()}/remove" class="btn btn-danger"><i class="fa fa-times"></i></a>`,
            `<a href="/${row.get('slug').toString()}" class="btn btn-info"><i class="fa fa-eye"></i></a>`,
            '</div>',
          ].join('');
        },
      });

    // add grid filters
    pageGrid.filter('slug', {
      title : 'Slug',
      type  : 'text',
      query : async (param) => {
        // another where
        pageGrid.where({
          slug : new RegExp(param.toString().toLowerCase(), 'i'),
        });
      },
    }).filter('title', {
      title : 'Title',
      type  : 'text',
      query : async (param) => {
        // another where
        pageGrid.where({
          [`title.${req.language}`] : new RegExp(param.toString().toLowerCase(), 'i'),
        });
      },
    }).filter('created_at', {
      title : 'Created',
      type  : 'date',
      query : async (param) => {
        // set extend
        pageGrid.gte('created_at', new Date(param.start));
        pageGrid.lte('created_at', new Date(param.end));
      },
    }).filter('updated_at', {
      title : 'Updated',
      type  : 'date',
      query : async (param) => {
        // set extend
        pageGrid.gte('updated_at', new Date(param.start));
        pageGrid.lte('updated_at', new Date(param.end));
      },
    });

    // set default sort order
    pageGrid.sort('created_at', 1);

    // return grid
    return pageGrid;
  }
}

/**
 * export PageAdminController controller
 *
 * @type {ADMIN}
 */
module.exports = PageAdminController;
