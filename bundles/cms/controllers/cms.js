
// bind dependencies
const Controller = require('controller');

// require models
const Page      = model('page');
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
    this.middlewareAction = this.middlewareAction.bind(this);

    // run build method
    this.build();
  }

  /**
   * build Block controller
   */
  build() {
    // on render
    this.eden.router.use(this.middlewareAction);

    // on render
    this.eden.pre('view.compile', async ({ res, render }) => {
      // set Block
      render.placements = {};

      // move menus
      if (res.placements) {
        // await promise
        await Promise.all(res.placements.map(async (position) => {
        // get Block
          const placement = await Placement.findOne({
            position,
          });

          // set null or Block
          render.placements[position] = placement ? await placement.sanitise(render.req) : null;
        }));
      }

      // check blocks
      if (!render.blocks && !render.isJSON) {
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
    return res.render('page', {
      item   : await page.sanitise(req),
      title  : page.get('title')[req.language],
      blocks : BlockHelper.renderBlocks('frontend'),
      layout : page.get('layout') || 'main',
    });
  }

  /**
   * middleware for Block
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   */
  middlewareAction(req, res, next) {
    // set Block
    res.placements = [];

    // create Block method
    const middlePlacement = (placement) => {
      // check locals
      if (!Array.isArray(res.placements)) res.placements = [];

      // push placement to Block
      if (res.placements.includes(placement)) return;

      // add to Block
      res.placements.push(placement);
    };

    // set to req/res
    res.placement = req.placement = middlePlacement;

    // run next
    return next();
  }
}

/**
 * export CMSController controller
 *
 * @type {CMSController}
 */
module.exports = CMSController;
