
// bind dependencies
const Controller = require('controller');

// require models
const Page  = model('page');
const Block = model('block');

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
  constructor () {
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
  build () {
    // on render
    this.eden.router.use(this._middleware);

    // on render
    this.eden.pre('view.compile', async (render) => {
      // set Block
      render.blocks = {};

      // move menus
      if (render.state.placements) await Promise.all(render.state.placements.map(async (placement) => {
        // get Block
        let Blocks = await Block.find({
          'placement' : placement
        });

        // set null or Block
        render.blocks[placement] = Blocks && Blocks.length ? await Promise.all(Blocks.map((block) => block.sanitise())) : [];
      }));

      // delete from state
      delete render.state.placements;
    });
  }

  /**
   * gets blocks
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   *
   * @route {post} /blocks/:placement
   */
  async blocksAction (req, res) {
    // return JSON blocks
    let Blocks = await Block.find({
      'placement' : req.params.placement
    });

    // return JSON stringify
    res.json(Blocks && Blocks.length ? await Promise.all(Blocks.map((block) => block.sanitise())) : []);
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
  async pageAction (req, res, next) {
    // load Page
    if (!req.params.page || !req.params.page.length) return next();

    // load Page
    let page = await Page.findOne({
      'slug' : req.params.page
    });

    // check Page
    if (!page) return next();

    // render Page
    res.render('page', {
      'item'   : await page.sanitise(req),
      'title'  : page.get('title')[req.language],
      'layout' : page.get('layout') || 'main'
    });
  }

  /**
   * middleware for Block
   *
   * @param  {Request}   req
   * @param  {Response}  res
   * @param  {Function}  next
   */
  _middleware (req, res, next) {
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
