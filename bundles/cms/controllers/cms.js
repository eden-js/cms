
// bind dependencies
const Controller = require('controller');

// require models
const Page      = model('page');
const Block     = model('block');
const Placement = model('placement');

// require helpers
const BlockHelper = helper('cms/block');

/**
 * build Block controller
 *
 * @mount    /
 * @priority 50
 */
class CMSController extends Controller {
  /**
   * construct Block controller
   */
  constructor() {
    // run super
    super();

    // bind methods
    this.build = this.build.bind(this);

    // bind private methods
    this._middleware = this._middleware.bind(this);

    // run build method
    this.build();
  }

  /**
   * build Block controller
   */
  build() {
    // on render
    this.eden.router.use(this._middleware);

    // on render
    this.eden.pre('view.compile', async (render) => {
      // set Block
      render.placements = {};

      // move menus
      if (render.state.placements) {
        // await promise
        await Promise.all(render.state.placements.map(async (position) => {
        // get Block
          const placement = await Placement.findOne({
            position,
          });

          // set null or Block
          render.placements[position] = placement ? await placement.sanitise(render.req) : null;
        }));
      }

      // check blocks
      if (!render.blocks) {
        // render blocks
        render.blocks = BlockHelper.renderBlocks('frontend');
      }
    });
  }

  /**
   * Index action
   *
   * @param    {Request}  req
   * @param    {Response} res
   *
   * @name     HOME
   * @route    {get} /
   * @menu     {MAIN} Home
   * @priority 2
   */
  async indexAction(req, res) {
    // set placements
    req.placement('home');

    // render Page
    res.render('cms/home');
  }

  /**
   * create custom Pages
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   *
   * @route     {get} /:page
   * @priority  100
   */
  async pageAction(req, res, next) {
    // load Page
    if (!req.params.page || !req.params.page.length) return next();

    // load Page
    const page = await Page.findOne({
      slug : req.params.page,
    });

    // check Page
    if (!page) return next();

    // render Page
    res.render('page', {
      item   : await page.sanitise(req),
      title  : page.get('title')[req.language],
      blocks : BlockHelper.renderBlocks('frontend'),
      layout : page.get('layout') || 'main'
    });
  }

  /**
   * middleware for Block
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   */
  _middleware(req, res, next) {
    // set Block
    res.locals.placements = [];

    // create Block method
    res.placement = req.placement = (placement) => {
      // check locals
      if (!Array.isArray(res.locals.placements)) res.locals.placements = [];

      // push placement to Block
      if (res.locals.placements.includes(placement)) return;

      // add to Block
      res.locals.placements.push(placement);
    };

    // run next
    return next();
  }
}

/**
 * export CMSController controller
 *
 * @type {CMSController}
 */
exports = module.exports = CMSController;
