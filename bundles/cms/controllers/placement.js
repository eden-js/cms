
// require dependencies
const Grid       = require('grid');
const socket     = require('socket');
const Controller = require('controller');

// require models
const Block     = model('block');
const Placement = model('placement');

// require helpers
const ModelHelper = helper('model');
const BlockHelper = helper('cms/block');

/**
 * build placement controller
 *
 * @mount /placement
 */
class PlacementController extends Controller {
  /**
   * construct user PlacementController controller
   */
  constructor () {
    // run super
    super();

    // bind methods
    this.viewAction   = this.viewAction.bind(this);
    this.updateAction = this.updateAction.bind(this);
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.listen.placement
   * @return {Async}
   */
  async listenAction (id, uuid, opts) {
    // join room
    opts.socket.join('placement.' + id);

    // add to room
    return await ModelHelper.listen(opts.sessionID, await Placement.findById(id), uuid);
  }

  /**
   * socket listen action
   *
   * @param  {String} id
   * @param  {Object} opts
   *
   * @call   model.deafen.placement
   * @return {Async}
   */
  async liveDeafenAction (id, uuid, opts) {
    // add to room
    return await ModelHelper.deafen(opts.sessionID, await Placement.findById(id), uuid);
  }

  /**
   * add/edit action
   *
   * @route    {get} /:id/view
   * @layout   admin
   * @priority 12
   */
  async viewAction (req, res) {
    // set website variable
    let create    = true;
    let placement = new Placement();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      placement = await Placement.findById(req.params.id);
    }

    // res JSON
    let sanitised = await placement.sanitise();

    // return JSON
    res.json({
      'state'  : 'success',
      'result' : (await Promise.all((placement.get('blocks') || []).map(async (block) => {
        // get from register
        let registered = BlockHelper.blocks().find((b) => b.type === block.type);

        // check registered
        if (!registered) return null;

        // get data
        let data = await registered.render(req, block);

        // set uuid
        data.uuid = block.uuid;

        // return render
        return data;
      }))).filter((w) => w),
      'message' : 'Successfully got blocks'
    });
  }

  /**
   * save block action
   *
   * @route    {post} /:id/block/save
   * @layout   admin
   * @priority 12
   */
  async saveBlockAction (req, res) {
    // set website variable
    let create    = true;
    let placement = new Placement();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      placement = await Placement.findById(req.params.id);
    }

    // get block
    let blocks = placement.get('blocks') || [];
    let current = blocks.find((block) => block.uuid === req.body.block.uuid);

    // update
    let registered = BlockHelper.blocks().find((w) => w.type === current.type);

    // await save
    await registered.save(req, current);

    // get rendered
    let rendered = await registered.render(req, current);

    // set uuid
    rendered.uuid = req.body.block.uuid;

    // emit
    socket.room('placement.' + placement.get('_id').toString(), 'placement.' + placement.get('_id').toString() + '.block', rendered);

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : rendered,
      'message' : 'Successfully saved block'
    });
  }

  /**
   * remove block action
   *
   * @route    {post} /:id/block/remove
   * @layout   admin
   * @priority 12
   */
  async removeBlockAction (req, res) {
    // get notes block from db
    let blockModel = await Block.findOne({
      'uuid' : req.body.block.uuid
    }) || new Block({
      'uuid' : req.body.block.uuid,
      'type' : req.body.block.type
    });

    // remove block
    if (blockModel.get('_id')) await blockModel.remove();

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : null,
      'message' : 'Successfully removed block'
    });
  }

  /**
   * create submit action
   *
   * @route  {post} /create
   * @layout admin
   */
  createAction () {
    // return update action
    return this.updateAction(...arguments);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route {post} /:id/update
   */
  async updateAction (req, res) {
    // set website variable
    let create    = true;
    let placement = new Placement();

    // check for website model
    if (req.params.id) {
      // load by id
      create    = false;
      placement = await Placement.findById(req.params.id);
    }

    // update placement
    placement.set('type',       req.body.type);
    placement.set('name',       req.body.name);
    placement.set('blocks',    req.body.blocks);
    placement.set('placements', req.body.placements);

    // save placement
    await placement.save();

    // send alert
    req.alert('success', 'Successfully ' + (create ? 'Created' : 'Updated') + ' placement!');

    // return JSON
    res.json({
      'state'   : 'success',
      'result'  : await placement.sanitise(),
      'message' : 'Successfully updated placement'
    });
  }
}

/**
 * export placement controller
 *
 * @type {PlacementController}
 */
module.exports = PlacementController;
