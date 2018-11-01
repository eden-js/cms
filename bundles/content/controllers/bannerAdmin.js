/**
 * Created by Awesome on 1/30/2016.
 */

// use strict
'use strict';

// require dependencies
const Grid       = require('grid');
const Controller = require('controller');

// require models
const Image  = model('image');
const Banner = model('banner');

/**
 * build banner controller
 *
 * @acl   admin
 * @fail  next
 * @mount /admin/banner
 */
class BannerAdminController extends Controller {
  /**
   * construct user bannerAdminController controller
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
   * @icon    fa fa-images
   * @menu    {ADMIN} banners
   * @title   banner Administration
   * @route   {get} /
   * @layout  admin
   */
  async indexAction (req, res) {
    // render grid
    res.render('banner/admin', {
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
    let create = true;
    let banner = new banner();

    // check for website model
    if (req.params.id) {
      // load by id
      create = false;
      banner = await banner.findById(req.params.id);
    }

    // render page
    res.render('banner/admin/update', {
      'item'  : await banner.sanitise(),
      'title' : create ? 'Create banner' : 'Update ' + banner.get('_id').toString()
    });
  }

  /**
   * create submit action
   *
   * @route   {post} /create
   * @layout  admin
   * @upload  {single} image
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
   * @upload  {single} image
   */
  async updateSubmitAction (req, res) {
    // set website variable
    let banner = new Banner();
    let create = true;

    // check for website model
    if (req.params.id) {
      // load by id
      banner = await banner.findById(req.params.id);
      create = false;
    }

    // let image
    let image = null;

    // check avatar
    if (req.file) {
      // create avatar
      let image = new Image();

      // run try/catch
      try {
        // load image
        await image.file(req.file.path, req.file.originalname);

        // create thumb
        let ThumbSm = image.thumb('sm-sq');
        let ThumbMd = image.thumb('md-banner');

        // resize
        await ThumbSm.resize(350, 350).png ().save ();

        // resize
        await ThumbMd.resize(1024, 900).png ().save ();

        // save image
        await image.save();

        // set avatar
        banner.set('image', image);
      } catch (e) {
        // check error
        res.alert('error', 'File error: "' + e.toString() + '", please try another image.');
      }
    }

    // update banner
    banner.set('title',   req.body.title);
    banner.set('content', req.body.content);

    // save banner
    await banner.save();

    // check image
    if (image) {
      // set image
      image.set('banner', banner);

      // save image
      await image.save();
    }

    // send alert
    req.alert('success', 'Successfully ' + (create ? 'Created' : 'Updated') + ' banner!');

    // render page
    res.render('banner/admin/update', {
      'item'  : await banner.sanitise(),
      'title' : create ? 'Create banner' : 'Update ' + banner.get('_id').toString()
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
    let banner = false;

    // check for website model
    if (req.params.id) {
      // load user
      banner = await Banner.findById(req.params.id);
    }

    // render page
    res.render('banner/admin/remove', {
      'item'  : await banner.sanitise(),
      'title' : 'Remove ' + banner.get('_id').toString()
    });
  }

  /**
   * delete action
   *
   * @param req
   * @param res
   *
   * @route   {post} /:id/remove
   * @title   Remove banner
   * @layout  admin
   */
  async removeSubmitAction (req, res) {
    // set website variable
    let banner = false;

    // check for website model
    if (req.params.id) {
      // load user
      banner = await Banner.findById(req.params.id);
    }

    // alert Removed
    req.alert('success', 'Successfully removed ' + (banner.get('_id').toString()));

    // delete website
    await banner.remove();

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
    let bannerGrid = new Grid();

    // set route
    bannerGrid.route('/admin/banner/grid');

    // set grid model
    bannerGrid.model(Banner);

    // add grid columns
    bannerGrid.column('_id', {
      'title'  : 'ID',
      'width'  : '1%',
      'format' : async (col) => {
        return col ? '<a href="/admin/banner/' + col.toString() + '/update">' + col.toString() + '</a>' : '<i>N/A</i>';
      }
    }).column('title', {
      'sort'   : true,
      'title'  : 'Title',
      'format' : async (col, row) => {
        return col ? ((col || {})[req.language] || '').toString() : '<i>N/A</i>';
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
            '<a href="/admin/banner/' + row.get('_id').toString() + '/update" class="btn btn-primary"><i class="fa fa-pencil"></i></a>',
            '<a href="/admin/banner/' + row.get('_id').toString() + '/remove" class="btn btn-danger"><i class="fa fa-times"></i></a>',
          '</div>'
        ].join ('');
      }
    });

    // add grid filters
    bannerGrid.filter('title', {
      'title' : 'Title',
      'type'  : 'text',
      'query' : async (param) => {
        // another where
        bannerGrid.where ({
          ['title.' + req.language] : new RegExp(param.toString().toLowerCase(), 'i')
        });
      }
    });

    // set default sort order
    bannerGrid.sort('created_at', 1);

    // return grid
    return bannerGrid;
  }
}

/**
 * export banner controller
 *
 * @type {bannerAdminController}
 */
module.exports = bannerAdminController;
