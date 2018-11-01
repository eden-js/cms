
// bind dependencies
const Grid       = require('grid');
const slug       = require('slug');
const alert      = require('alert');
const config     = require('config');
const Controller = require('controller');

// require models
const Block = model('block');

/**
 * build user BlockAdminController controller
 *
 * @acl   admin.block.view
 * @fail  /
 * @mount /admin/block
 */
class BlockAdminController extends Controller {
  /**
   * construct user BlockAdminController controller
   */
  constructor () {
    // run super
    super();

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
   * @icon    fa fa-th-large
   * @menu    {ADMIN} Block
   * @title   Block Administration
   * @route   {get} /
   * @layout  admin
   */
  async indexAction (req, res) {
    // render grid
    res.render('block/admin', {
      'grid' : await this._grid(req).render(req)
    });
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route    {get} /create
   * @layout   admin
   * @priority 12
   */
  createAction (req, res) {
    // return update action
    return this.updateAction(req, res);
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
    let block  = new Block();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      block  = await Block.findById(req.params.id);
      create = false;
    }

    // render page
    res.render ('block/admin/update', {
      'item'      : await block.sanitise(),
      'title'     : create ? 'Create block' : 'Update ' + block.get('_id').toString(),
      'redirect'  : req.query.redirect,
      'placement' : req.query.placement
    });
  }

  /**
   * create submit action
   *
   * @param req
   * @param res
   *
   * @route   {post} /create
   * @layout  admin
   */
  createSubmitAction (req, res) {
    // return update action
    return this.updateSubmitAction(req, res);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/update
   * @layout  admin
   * @upload  {any}
   */
  async updateSubmitAction (req, res) {
    // set website variable
    let block  = new Block();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      block  = await Block.findById(req.params.id);
      create = false;
    }

    // update block
    block.set('type',      req.body.type);
    block.set('title',     req.body.title);
    block.set('content',   req.body.content);
    block.set('placement', req.body.placement);

    // save block
    await block.save();

    // send alert
    req.alert('success', 'Successfully ' + (create ? 'Created' : 'Updated') + ' block!');

    // check redirect
    if (req.body.redirect) return res.redirect(req.body.redirect);

    // render page
    res.render('block/admin/update', {
      'item'  : await block.sanitise(),
      'title' : create ? 'Create block' : 'Update ' + block.get('_id').toString()
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
    let block = false;

    // check for website model
    if (req.params.id) {
      // load user
      block = await Block.findById(req.params.id);
    }

    // render page
    res.render('block/admin/remove', {
      'item'     : await block.sanitise(),
      'title'    : 'Remove ' + block.get('_id').toString(),
      'redirect' : req.query.redirect
    });
  }

  /**
   * delete action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/remove
   * @title   Remove Block
   * @layout  admin
   */
  async removeSubmitAction (req, res) {
    // set website variable
    let block = false;

    // check for website model
    if (req.params.id) {
      // load user
      block = await Block.findById(req.params.id);
    }

    // alert Removed
    req.alert('success', 'Successfully removed ' + (block.get('_id').toString()));

    // delete website
    await block.remove();

    // render index
    res.redirect(req.body.redirect || '/admin/block');
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
    let blockGrid = new Grid();

    // set route
    blockGrid.route('/admin/block/grid');

    // set grid model
    blockGrid.model(Block);

    // add grid columns
    blockGrid.column('_id', {
      'title'  : 'ID',
      'width'  : '1%',
      'format' : async (col) => {
        return col ? '<a href="/admin/block/' + col.toString() + '/update">' + col.toString() + '</a>' : '<i>N/A</i>';
      }
    }).column('title', {
      'sort'   : true,
      'title'  : 'Title',
      'format' : async (col, row) => {
        return col && col[req.language] ? col[req.language].toString() : '<i>N/A</i>';
      }
    }).column('placement', {
      'sort'   : true,
      'title'  : 'Placement',
      'format' : async (col, row) => {
        return col ? col.toString() : '<i>N/A</i>';
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
    }).column ('actions', {
      'type'   : false,
      'width'  : '1%',
      'title'  : 'Actions',
      'format' : async (col, row) => {
        return [
          '<div class="btn-group btn-group-sm" role="group">',
            '<a href="/admin/block/' + row.get('_id').toString() + '/update" class="btn btn-primary"><i class="fa fa-pencil"></i></a>',
            '<a href="/admin/block/' + row.get('_id').toString() + '/remove" class="btn btn-danger"><i class="fa fa-times"></i></a>',
          '</div>'
        ].join('');
      }
    });

    // add grid filters
    blockGrid.filter('placement', {
      'title' : 'Placement',
      'type'  : 'text',
      'query' : async (param) => {
        // another where
        blockGrid.match('placement', new RegExp(param.toString().toLowerCase(), 'i'));
      }
    }).filter('title', {
      'title' : 'Title',
      'type'  : 'text',
      'query' : async (param) => {
        // another where
        blockGrid.match('title.' + req.language, new RegExp(param.toString().toLowerCase(), 'i'));
      }
    }).filter('created_at', {
      'title' : 'Created',
      'type'  : 'date',
      'query' : async (param) => {
        // set extend
        blockGrid.lte('created_at', new Date(param.start));
        blockGrid.gte('created_at', new Date(param.end));
      }
    }).filter('updated_at', {
      'title' : 'Updated',
      'type'  : 'date',
      'query' : async (param) => {
        // set extend
        blockGrid.lte('updated_at', new Date(param.start));
        blockGrid.gte('updated_at', new Date(param.end));
      }
    });

    // set default sort order
    blockGrid.sort('updated_at', 1);

    // return grid
    return blockGrid;
  }
}

/**
 * export BlockAdminController controller
 *
 * @type {ADMIN}
 */
exports = module.exports = BlockAdminController;
