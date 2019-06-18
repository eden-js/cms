/**
 * Created by Awesome on 1/30/2016.
 */

// use strict


// require dependencies
const controller = require('controller');

// require models
const File  = model('file');
const Image = model('image');

/**
 * build media controller
 *
 * @mount /media
 */
class mediaController extends controller {
  /**
   * construct media class
   */
  constructor() {
    // run super eden
    super();

    // pre image sanitise
    this.eden.pre('image.sanitise', async (data) => {
      // check from gallery
      if (data.image.get('from') !== 'gallery') return;

      // do sanitised
      data.sanitised.caption = await data.image.get('caption');
      data.sanitised.category = await data.image.get('category') ? await (await data.image.get('category')).sanitise() : null;
      data.sanitised.published = await data.image.get('published');
    });
  }

  /**
   * index action
   *
   * @param req
   * @param res
   *
   * @acl      true
   * @route    {post} /file
   * @upload   {single} file
   * @priority 2
   */
  async fileAction(req, res) {
    // check if upload
    if (!req.file) {
      return res.json({
        error   : true,
        message : req.t('file empty'),
      });
    }

    // create avatar
    const upload = new File();

    // load image
    if (req.file.path) {
      // from file
      await upload.fromFile(req.file.path, req.file.originalname);
    } else {
      // from buffer
      await upload.fromBuffer(req.file.buffer, req.file.originalname);
    }

    // set user
    upload.set('temp', req.body.temp);
    upload.set('user', req.user);

    // save image
    await upload.save(req.user);

    // return image
    const sanitised = await upload.sanitise();

    // set variables
    sanitised.user = await req.user.sanitise();
    sanitised.temp = upload.get('temp');

    // return json
    res.json({
      error  : false,
      upload : sanitised,
    });

    // do alert
    return req.alert('success', req.t('Successfully uploaded file'));
  }

  /**
   * index action
   *
   * @param req
   * @param res
   *
   * @acl      true
   * @route    {post}   /image
   * @upload   {single} file
   * @priority 2
   */
  async imageAction(req, res) {
    // check if upload
    if (!req.file) {
      return res.json({
        error   : true,
        message : req.t('file empty'),
      });
    }

    // create avatar
    const image = new Image();

    // load image
    if (req.file.path) {
      // from file
      await image.fromFile(req.file.path, req.file.originalname);
    } else {
      // from buffer
      await image.fromBuffer(req.file.buffer, req.file.originalname);
    }

    // resize image
    await (await image.thumb('1x')).resize(400, 400, {
      fit : 'contain',
    }).png().save();
    await (await image.thumb('2x')).resize(800, 800, {
      fit : 'contain',
    }).png().save();
    await (await image.thumb('3x')).resize(1200, 1200, {
      fit : 'contain',
    }).png().save();

    // resize image in square
    await (await image.thumb('sm-sq')).resize(400, 400, {
      fit        : 'contain',
      background : {
        r     : 0,
        g     : 0,
        b     : 0,
        alpha : 0,
      },
    }).png().save();
    await (await image.thumb('md-sq')).resize(800, 800, {
      fit        : 'contain',
      background : {
        r     : 0,
        g     : 0,
        b     : 0,
        alpha : 0,
      },
    }).png().save();
    await (await image.thumb('lg-sq')).resize(1200, 1200, {
      fit        : 'contain',
      background : {
        r     : 0,
        g     : 0,
        b     : 0,
        alpha : 0,
      },
    }).png().save();

    // resize image
    await (await image.thumb('1x-sq')).resize(400, 400, {
      fit : 'cover',
    }).png().save();
    await (await image.thumb('2x-sq')).resize(800, 800, {
      fit : 'cover',
    }).png().save();
    await (await image.thumb('3x-sq')).resize(1200, 1200, {
      fit : 'cover',
    }).png().save();

    // set user
    image.set('temp', req.body.temp);
    image.set('user', req.user);

    // save image
    await image.save(req.user);

    // return image
    const sanitised = await image.sanitise();

    // set variables
    sanitised.user = await req.user.sanitise();
    sanitised.temp = image.get('temp');

    // return json
    res.json({
      error  : false,
      upload : sanitised,
    });

    // do alert
    return req.alert('success', req.t('Successfully uploaded image'));
  }
}

/**
 * export media controller
 *
 * @type {mediaController}
 */
module.exports = mediaController;
