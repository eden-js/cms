/* eslint-disable no-empty */

// require dependencies
const socket     = require('socket');
const Controller = require('controller');

// require models
const Block     = model('block');
const Placement = model('placement');

// require helpers
const syncHelper  = helper('sync');
const blockHelper = helper('cms/block');

/**
 * build placement controller
 *
 * @mount /placement
 */
class PlacementController extends Controller {
  /**
   * construct user PlacementController controller
   */
  constructor() {
    // run super
    super();

    // bind methods
    this.viewAction = this.viewAction.bind(this);
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
  async listenAction(id, uuid, opts) {
    // / return if no id
    if (!id) return null;

    // join room
    opts.socket.join(`placement.${id}`);

    // add to room
    return await syncHelper.addListener(await Placement.findById(id), {
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
   * @call   model.deafen.placement
   * @return {Async}
   */
  async deafenAction(id, uuid, opts) {
    // / return if no id
    if (!id) return null;

    // join room
    opts.socket.leave(`placement.${id}`);

    // add to room
    return await syncHelper.removeListener(await Placement.findById(id), {
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
   * @route    {get} /:position/position
   * @layout   admin
   * @priority 12
   */
  async viewAction(req, res) {
    // set website variable
    let placement = new Placement();

    // check for website model
    if (req.params.id) {
      // load by id
      placement = await Placement.findById(req.params.id);
    }

    // check for website model
    if (req.params.position) {
      // load by id
      placement = await Placement.findOne({
        position : req.params.position,
      });
    }

    // check placement
    if (!placement) {
      // fail state
      return res.json({
        state : 'fail',
      });
    }

    // return JSON
    return res.json({
      state   : 'success',
      result  : await placement.sanitise(req),
      message : 'Successfully got blocks',
    });
  }

  /**
   * save block action
   *
   * @route    {post} /:id/block/save
   * @layout   admin
   * @priority 12
   */
  async saveBlockAction(req, res) {
    // set website variable
    let placement = new Placement({
      position : req.body.position,
    });

    // run try/catch
    try {
      // check for website model
      if (req.params.id && req.params.id !== 'undefined' && req.params.id !== 'null') {
        // load by id
        placement = await Placement.findById(req.params.id);
      }
    } catch (e) { }

    // get block
    const blocks  = placement.get('elements') || [];
    const current = blocks.find(block => block.uuid === req.body.block.uuid);

    // check current
    if (!current) {
      // push block
      blocks.push(req.body.block);
    } else {
      // set keys
      Object.keys(req.body.block).forEach((key) => {
        // set value
        current[key] = req.body.block[key];
      });
    }

    // update
    const registered = blockHelper.blocks().find(w => w.type === current.type);

    // await save
    if (registered) await registered.save(req, req.body.block);

    // get rendered
    const rendered = await registered.render(req, req.body.block);

    // set uuid
    rendered.uuid = req.body.block.uuid;

    // set elements
    placement.set('elements', blocks);
    await placement.save();

    // emit
    socket.room(`placement.${placement.get('_id').toString()}`, `placement.${placement.get('_id').toString()}.block`, rendered);

    // return JSON
    return res.json({
      state   : 'success',
      result  : rendered,
      message : 'Successfully saved block',
    });
  }

  /**
   * remove block action
   *
   * @route    {post} /:id/block/remove
   * @layout   admin
   * @priority 12
   */
  async removeBlockAction(req, res) {
    // set website variable
    let placement = new Placement({
      position : req.body.position,
    });

    // run try/catch
    try {
      // check for website model
      if (req.params.id && req.params.id !== 'undefined' && req.params.id !== 'null') {
        // load by id
        placement = await Placement.findById(req.params.id);
      }
    } catch (e) { }

    // get block
    const blocks = placement.get('elements') || [];

    // set elements
    placement.set('elements', blocks.filter(block => block.uuid !== req.body.block.uuid));
    await placement.save();

    // get notes block from db
    const blockModel = await Block.findOne({
      uuid : req.body.block.uuid,
    });

    // remove block
    if (blockModel) await blockModel.remove(req.user);

    // return JSON
    res.json({
      state   : 'success',
      result  : null,
      message : 'Successfully removed block',
    });
  }

  /**
   * create submit action
   *
   * @route  {post} /create
   * @layout admin
   */
  createAction(...args) {
    // return update action
    return this.updateAction(...args);
  }

  /**
   * add/edit action
   *
   * @param req
   * @param res
   *
   * @route {post} /:id/update
   */
  async updateAction(req, res) {
    // set website variable
    let create = true;
    let placement = new Placement();

    // check for website model
    if (req.params.id) {
      // load by id
      create = false;
      placement = await Placement.findById(req.params.id);
    }

    // update placement
    placement.set('name',      req.body.name);
    placement.set('elements',  req.body.elements);
    placement.set('position',  req.body.position);
    placement.set('positions', req.body.positions);

    // save placement
    await placement.save(req.user);

    // send alert
    req.alert('success', `Successfully ${create ? 'Created' : 'Updated'} placement!`);

    // return JSON
    res.json({
      state   : 'success',
      result  : await placement.sanitise(req),
      message : 'Successfully updated placement',
    });
  }
}

/**
 * export placement controller
 *
 * @type {PlacementController}
 */
module.exports = PlacementController;
