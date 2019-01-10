<eden-blocks>
  <div ref="placement" class="eden-blocks">

    <div class="{ 'eden-dropzone' : this.acl.validate('admin') && !opts.preview } { 'empty' : !getBlocks().length }" ref="placement" data-placement="" if={ !this.updating }>
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') && !opts.preview }>
        { this.placement.get('position') }
      </span>
      <eden-add type="top" onclick={ onAddBlock } way="unshift" placement="" if={ this.acl.validate('admin') && !opts.preview } />
      <div each={ el, i in getBlocks() } el={ el } no-reorder class={ el.class } data-is={ getElement(el) } preview={ opts.preview } data-block={ el.uuid } data={ getBlock(el) } block={ el } get-block={ getBlock } on-add-block={ onAddBlock } on-save={ this.onSaveBlock } on-remove={ onRemoveBlock } on-refresh={ this.onRefreshBlock } placement={ i } i={ i } />
      <eden-add type="bottom" onclick={ onAddBlock } way="push" placement="" if={ this.acl.validate('admin') && !opts.preview } />
    </div>
  </div>

  <block-modal blocks={ opts.blocks } add-block={ onSetBlock } />

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('model');

    // require uuid
    const uuid = require('uuid');

    // set update
    this.blocks    = (opts.placement || {}).render || [];
    this.loading   = {};
    this.updating  = false;
    this.position  = opts.position;
    this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});
      
    // set flattened blocks
    const fix = (block) => {
      // standard children elements
      let children = ['left', 'right', 'children'];
      
      // return if moving
      if (!block) return;

      // check children
      for (let child of children) {
        // check child
        if (block[child]) {
          // remove empty blocks
          block[child] = Object.values(block[child]).filter((block) => block);

          // push children to flat
          block[child] = block[child].map(fix);
        }
      }

      // return accum
      return block;
    };
      
    // set flattened blocks
    const place = (block) => {
      // standard children elements
      let children = ['left', 'right', 'children'];
      
      // return if moving
      if (block.moving || block.removing) return;

      // check children
      for (let child of children) {
        // check child
        if (block[child]) {
          // remove empty blocks
          block[child] = Object.values(block[child]);

          // push children to flat
          block[child] = block[child].map(place).filter((block) => block);
        }
      }

      // return accum
      return block;
    };

    // set flattened blocks
    const flatten = (accum, block) => {
      // standard children elements
      let children = ['left', 'right', 'children'];

      // get sanitised
      let sanitised = JSON.parse(JSON.stringify(block));

      // loop for of
      for (let child of children) {
        // delete child field
        delete sanitised[child];
        delete sanitised.saving;
      }

      // check block has children
      accum.push(sanitised);

      // check children
      for (let child of children) {
        // check child
        if (block[child]) {
          // remove empty blocks
          block[child] = block[child].filter((block) => block);

          // push children to flat
          accum.push(...block[child].reduce(flatten, []));
        }
      }

      // return accum
      return accum;
    };

    /**
     * get block data
     *
     * @param  {Object} block
     *
     * @return {*}
     */
    getBlock (block) {
      // return on no block
      if (!block) return;

      // get found
      let found = this.blocks.find((b) => b.uuid === block.uuid);

      // gets data for block
      if (!found) return null;

      // return found
      return found;
    }

    /**
     * get element
     *
     * @param  {Object} child
     *
     * @return {*}
     */
    getElement (child) {
      // return get child
      return (this.getBlock(child) || {}).tag ? 'block-' + (this.getBlock(child) || {}).tag : 'eden-loading';
    }

    /**
     * get blocks
     *
     * @return {Array}
     */
    getBlocks () {
      // return filtered blocks
      return (this.placement.get('positions') || []).map(fix).filter((block) => block);
    }

    /**
     * on add block
     *
     * @param  {Event} e
     *
     * @return {*}
     */
    onAddBlock (e) {
      // get target
      let target = !jQuery(e.target).is('eden-add') ? jQuery(e.target).closest('eden-add') : jQuery(e.target);

      // way
      this.way      = target.attr('way');
      this.position = target.attr('placement');

      // open modal
      jQuery('.add-block-modal', this.root).modal('show');
    }

    /**
     * on refresh block
     *
     * @param  {Event}  e
     * @param  {Object} block
     */
    async onSaveBlock (block, data, placement, preventUpdate) {
      // clone
      let blockClone = Object.assign({}, block);

      // prevent update check
      if (!preventUpdate) {
        // set loading
        block.saving = true;

        // update view
        this.update();
      }

      // log data
      let res = await fetch('/placement/' + this.placement.get('id') + '/block/save', {
        'body' : JSON.stringify({
          'data'  : data,
          'block' : blockClone
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to placement
        data[key] = result.result[key];
      }
      
      // set to blocks
      if (!this.blocks.find((b) => b.uuid === data.uuid)) this.blocks.push(data);

      // set flat
      this.placement.set('elements', (this.placement.get('positions') || []).reduce(flatten, []));

      // save placement
      await this.savePlacement(this.placement, true);

      // check prevent update
      if (!preventUpdate) {
        // set loading
        delete block.saving;

        // update view
        this.update();
      }
    }

    /**
     * on refresh block
     *
     * @param  {Event}  e
     * @param  {Object} block
     */
    async onRefreshBlock (block, data) {
      // set loading
      block.refreshing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/placement/' + this.placement.get('id') + '/block/save', {
        'body' : JSON.stringify({
          'data'  : data,
          'block' : block
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // set logic
      for (let key in result.result) {
        // clone to placement
        data[key] = result.result[key];
      }

      // set loading
      delete block.refreshing;

      // update view
      this.update();
    }

    /**
     * on refresh block
     *
     * @param  {Event}  e
     * @param  {Object} block
     */
    async onRemoveBlock (block, data, placement) {
      // get uuid
      const dotProp = require('dot-prop');

      // set loading
      block.removing = true;

      // update view
      this.update();

      // log data
      let res = await fetch('/placement/' + this.placement.get('id') + '/block/remove', {
        'body' : JSON.stringify({
          'data'  : data,
          'block' : block
        }),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let result = await res.json();

      // get positions
      let positions = (this.placement.get('positions') || []).map(fix).filter((block) => block);
      
      // set moving on block
      positions = dotProp.set(positions, placement + '.removing', true);

      // get positions
      this.placement.set('positions', positions.map(place).filter((block) => block));
      this.placement.set('elements', (this.placement.get('positions') || []).reduce(flatten, []));

      // save placement
      await this.savePlacement(this.placement);
    }

    /**
     * adds block by type
     *
     * @param  {String} type
     *
     * @return {*}
     */
    async onSetBlock (type) {
      // get uuid
      const dotProp = require('dot-prop');

      // create block
      let block = {
        'uuid' : uuid(),
        'type' : type
      };

      // check positions
      if (!this.placement.get('positions')) this.placement.set('positions', []);

      // get from position
      let pos = (this.position || '').length ? dotProp.get(this.placement.get('positions'), this.position) : this.placement.get('positions');

      // force pos to exist
      if (!pos && (this.position || '').length) {
        // set pos
        pos = [];

        // set
        dotProp.set(this.placement.get('positions'), this.position, pos);
      }

      // do thing
      pos[this.way](block);

      // set flat
      this.placement.set('elements', (this.placement.get('positions') || []).reduce(flatten, []));

      // save placement
      await this.savePlacement(this.placement);
      await this.onSaveBlock(block, {});

      // update view
      this.update();
    }

    /**
     * saves placement
     *
     * @param {Object}  placement
     * @param {Boolean} preventRefresh
     *
     * @return {Promise}
     */
    async savePlacement (placement, preventRefresh) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!placement.type) placement.set('type', opts.type);

      // log data
      let res = await fetch('/placement/' + (placement.get('id') ? placement.get('id') + '/update' : 'create'), {
        'body'    : JSON.stringify(placement.get()),
        'method'  : 'post',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();
      
      // prevent clear
      if (!preventRefresh) {
        // reset positions
        placement.set('positions', []);

        // update view
        this.update();
      }

      // set in eden
      window.eden.placements[placement.get('position')] = data.result;

      // set logic
      for (let key in data.result) {
        // clone to placement
        placement.set(key, data.result[key]);

        // set in opts
        if (data.result[key]) opts.placement[key] = data.result[key];
      }

      // set placement
      this.placement = placement;

      // on save
      if (opts.onSave) opts.onSave(placement);

      // set loading
      this.loading.save = false;

      // update view
      this.update();
    }

    /**
     * loads placement blocks
     *
     * @param  {Object} opts
     *
     * @return {Promise}
     */
    async loadBlocks (opts) {
      // set opts
      if (!opts) opts = {};

      // require query string
      const qs = require('querystring');

      // set opts
      opts = qs.stringify(opts);

      // set loading
      this.loading.blocks = true;

      // update view
      this.update();

      // log data
      let res = await fetch((this.placement.get('id') ? ('/placement/' + this.placement.get('id') + '/view') : ('/placement/' + this.placement.get('position') + '/position')) + (opts.length ? '?' + opts : ''), {
        'method'  : 'get',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();
      
      // set in eden
      if (data.result) {
        // set in eden
        window.eden.placements[this.placement.get('position')] = data.result;

        // set blocks
        for (let key in data.result) {
          // set key
          this.placement.set(key, data.result[key]);
        }

        // set loading
        this.loading.blocks = false;
        
        // get blocks
        this.blocks = this.placement.get('render') || [];

        // update view
        this.update();
      }
    }

    /**
     * init dragula
     */
    initDragula () {
      // require dragula
      const dragula = require('dragula');
      const dotProp = require('dot-prop');

      // do dragula
      this.dragula = dragula(jQuery('.eden-dropzone', this.refs.placement).toArray(), {
        'moves' : (el, container, handle) => {
          return (jQuery(el).is('[data-block]') || jQuery(el).closest('[data-block]').length) && (jQuery(handle).is('.move') || jQuery(handle).closest('.move').length);
        }
      }).on('drop', (el, target, source, sibling) => {
        // get current placement
        let placement = jQuery(el).attr('placement');
        
        // check target
        if (!target || !source || !el) return;

        // get blocks of target
        let blocks = [];

        // get positions
        let positions = (this.placement.get('positions') || []).map(fix).filter((block) => block);
        
        // set moving on block
        positions = dotProp.set(positions, placement + '.moving', true);

        // loop physical blocks
        jQuery('> [data-block]', target).each((i, block) => {
          // set get from
          let getFrom = jQuery(block).attr('placement');
          let gotBlock = dotProp.get(positions, getFrom);
          
          // return on no block
          if (!gotBlock) return;

          // clone block
          if (getFrom === placement) {
            // clone block
            gotBlock = JSON.parse(JSON.stringify(gotBlock));
            
            // delete placing
            if (gotBlock.moving) delete gotBlock.moving;
          }

          // get actual block
          blocks.push(gotBlock);
        });

        // remove logic
        this.updating = true;
        this.update();

        // set placement
        if (jQuery(target).attr('data-placement').length) {
          // set positions
          positions = dotProp.set(positions, jQuery(target).attr('data-placement'), blocks);
        } else {
          // set positions
          positions = blocks;
        }

        // get positions
        positions = (positions || []).map(place).filter((block) => block);

        // update placement
        this.placement.set('positions', positions);

        // remove logic
        this.updating = false;
        this.update();

        // save
        this.savePlacement(this.placement);
      }).on('drag', (el, source) => {
        // add is dragging
        jQuery(this.refs.placement).addClass('is-dragging');
      }).on('dragend', () => {
        // remove is dragging
        jQuery(this.refs.placement).removeClass('is-dragging');
      }).on('over', function (el, container) {
        // add class
        jQuery(container).addClass('eden-block-over');
      }).on('out', function (el, container) {
        // remove class
        jQuery(container).removeClass('eden-block-over');
      });

      // on update
      this.on('update', () => {
        // set containers
        this.dragula.containers = jQuery('.eden-dropzone', this.refs.placement).toArray();
      });
    }

    /**
     * on update
     *
     * @type {update}
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // check type
      if ((opts.placement || {}).id !== this.placement.get('id') || opts.position !== this.position) {
        // set blocks
        this.placement.set('positions', []);

        // set type
        this.blocks = (opts.placement || {}).render || [];

        // trigger mount
        this.trigger('mount');
      }
    });

    /**
     * on mount
     *
     * @type {mount}
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // init dragula
      if (!this.dragula && this.acl.validate('admin')) this.initDragula();

      // set placement
      this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});

      // check default
      if (opts.positions && !(this.placement.get('positions') || []).length && !this.placement.get('id')) {
        // set default
        this.placement.set('positions', opts.positions);
        this.placement.set('elements', (this.placement.get('positions') || []).reduce(flatten, []));

        // save blocks
        this.savePlacement(this.placement);
      }
      
      // set positions
      if (opts.position !== this.position) {
        // set position
        this.position = opts.position;
        
        // get positions
        let positions = this.placement.get('positions') || [];
        
        // reset positions
        this.placement.set('positions', []);
        
        // update
        this.update();
        
        // set positions again
        this.placement.set('positions', positions);
        
        // update view again
        this.update();
      }

      // check blocks
      if ((this.placement.get('elements') || []).length !== this.blocks.length) {
        // load blocks
        this.loadBlocks();
      } else if (!(this.placement.get('elements') || []).length && !(this.eden.get('positions') || {})[this.placement.get('position')]) {
        // load blocks
        this.loadBlocks();
      }

      // loads block
      socket.on('placement.' + this.placement.get('id') + '.block', (block) => {
        // get found
        let found = this.blocks.find((b) => b.uuid === block.uuid);

        // check found
        if (!found) {
          // push
          this.blocks.push(block);

          // return update
          return this.update();
        }

        // set values
        for (let key in block) {
          // set value
          found[key] = block[key];
        }

        // update
        this.update();
      });
    });
  </script>
</eden-blocks>
