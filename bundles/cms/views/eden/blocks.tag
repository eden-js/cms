<eden-blocks>
  <div ref="placement" class="eden-blocks" if={ !this.placing }>

    <div class={ 'eden-dropzone' : this.acl.validate('admin') } ref="placement" data-placement="" if={ !this.updating }>
      <span class="eden-dropzone-label" if={ this.acl.validate('admin') }>
        Root
      </span>
      <eden-add type="top" onclick={ onAddBlock } way="unshift" placement="" if={ this.acl.validate('admin') } />
      <div each={ el, i in getBlocks() } el={ el } no-reorder data-is={ getElement(el) } data-block={ el.uuid } data={ getBlock(el) } block={ el } get-block={ getBlock } on-add-block={ onAddBlock } on-save={ this.onSaveBlock } on-remove={ onRemoveBlock } on-refresh={ this.onRefreshBlock } placement={ i } i={ i } />
      <eden-add type="bottom" onclick={ onAddBlock } way="push" placement="" if={ this.acl.validate('admin') } />
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
    this.rows      = [1, 2, 3, 4, 5, 6, 7, 8];
    this.type      = opts.type;
    this.blocks    = (opts.placement || {}).render || [];
    this.loading   = {};
    this.updating  = false;
    this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});

    /**
     * get block data
     *
     * @param  {Object} block
     *
     * @return {*}
     */
    getBlock (block) {
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
      return (this.placement.get('positions') || []).filter((child) => child);
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

        // set in placement
        opts.placement[data] = result.result[key];
      }

      // save placement
      await this.savePlacement(this.placement);

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
      const dotProp = require('dot-prop-immutable');

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

      // remove from everywhere
      this.placement.set('elements', this.placement.get('elements').filter((w) => {
        // check found in row
        return block.uuid !== w.uuid;
      }));

      // get final part
      placement = placement.toString().split('.');

      // get index
      let index = placement.pop();

      // join with dot
      placement = placement.join('.');

      // get from position
      let pos = (placement || '').length ? dotProp.get(this.placement.get('positions'), placement) : this.placement.get('positions');

      // delete from parent
      pos.splice(parseInt(index), 1);

      // update view
      this.update();

      // save placement
      await this.savePlacement(this.placement);

      // update view
      this.update();
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
      const dotProp = require('dot-prop-immutable');

      // create block
      let block = {
        'uuid' : uuid(),
        'type' : type
      };

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

      // set flattened blocks
      let flatten = (accum, block) => {
        // standard children elements
        let children = ['left', 'right', 'children'];

        // get sanitised
        let sanitised = JSON.parse(JSON.stringify(block));

        // loop for of
        for (let child of children) {
          // delete child field
          delete sanitised[child];
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
     * @param  {Object}  placement
     *
     * @return {Promise}
     */
    async savePlacement (placement) {
      // set loading
      this.loading.save = true;

      // update view
      this.update();

      // check type
      if (!placement.type) placement.set('type', opts.type || opts.placement);

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
     * @param  {Model} placement
     *
     * @return {Promise}
     */
    async loadBlocks (placement) {
      // set loading
      this.loading.blocks = true;

      // update view
      this.update();

      // check type
      if (!placement.type) placement.set('type', opts.type);

      // log data
      let res = await fetch('/placement/' + placement.get('id') + '/view', {
        'method'  : 'get',
        'headers' : {
          'Content-Type' : 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load data
      let data = await res.json();

      // set blocks
      this.blocks = data.result;

      // set loading
      this.loading.blocks = false;

      // update view
      this.update();
    }

    /**
     * init dragula
     */
    initDragula () {
      // require dragula
      const dragula = require('dragula');
      const dotProp = require('dot-prop-immutable');

      // do dragula
      this.dragula = dragula(jQuery('.eden-dropzone', this.refs.placement).toArray(), {
        'moves' : (el, container, handle) => {
          return (jQuery(el).is('[data-block]') || jQuery(el).closest('[data-block]').length) && (jQuery(handle).is('.move') || jQuery(handle).closest('.move').length);
        }
      }).on('drop', (el, target, source, sibling) => {
        // don't do anything if same placement
        if (jQuery(target).attr('data-placement') === jQuery(source).attr('data-placement')) return;

        // get current placement
        let placement = jQuery(el).attr('placement');

        // get blocks of target
        let blocks = [];

        // get positions
        let positions = this.placement.get('positions') || [];

        // loop physical blocks
        jQuery('> [data-block]', target).each((i, block) => {
          // get actual block
          blocks.push(dotProp.get(positions, jQuery(block).attr('placement')));
        });

        // remove logic
        this.updating = true;
        this.update();

        // delete placement
        dotProp.delete(positions, placement);

        // set placement
        positions = dotProp.set(positions, jQuery(target).attr('data-placement'), blocks);

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
      if (opts.type !== this.type || (opts.placement || {}).id !== this.placement.get('id')) {
        // set type
        this.type   = opts.type;
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
      if (!this.dragula) this.initDragula();

      // set placement
      this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});

      // check blocks
      if ((this.placement.get('elements') || []).length !== this.blocks.length) {
        // load blocks
        this.loadBlocks(this.placement);
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
