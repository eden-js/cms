<block>

  <!-- main view -->
  <div data-placement={ opts.placement } if={ !this.acl.validate('block.update') }>
    <div each={ block, i in this.blocks } block={ block } data-is="block-{ block.type || 'html' }" />
  </div>
  <!-- / main view -->

  <!-- edit view -->
  <div data-placement={ opts.placement } class={ 'block-edit' : true, 'hover' : isHovered() } if={ this.acl.validate('block.update') }>
    <div class="block-edit-title">
      Placement <code>{ opts.placement }</code>
    </div>

    <div if={ !this.blocks || !this.blocks.length } class="py-4" />

    <div each={ block, i in this.blocks } class={ 'block-edit-element' : true, 'hover' : block.quick }>
      <div class="block-edit-element-title">
        <div class="float-left">
          Block <code>{ block.id }</code>
        </div>
      </div>

      <div block={ renderBlock(block) } data-is="block-{ block.type || 'html' }{ block.quick ? '-quick' : '' }" on-update={ onUpdate } />

      <div class="block-edit-element-footer">
        <div class="float-right">
          <div class="btn-group">
            <button if={ !block.quick } onclick={ onToggleQuick } class="btn btn-sm btn-info">
              Quick
            </button>
            <a if={ !block.quick } href="/admin/block/{ block.id }/update" class="btn btn-sm btn-info">
              Update
            </a>
            <a if={ !block.quick } href="/admin/block/{ block.id }/remove?redirect={ this.eden.frontend ? window.eden.mount.url : '' }" class="btn btn-sm btn-danger">
              Remove
            </a>
            <button if={ block.quick } onclick={ onToggleQuick } class="btn btn-sm btn-danger">
              Cancel
            </button>
            <button if={ block.quick } onclick={ onSaveQuick } class={ 'btn btn-sm btn-success' : true, 'disabled' : block.saving } disabled={ block.saving }>
              { block.saving ? 'Saving...' : 'Save' }
            </button>
          </div>
        </div>
      </div>
    </div>


    <div class="block-edit-footer">
      <div class="float-right">
        <div class="btn-group">
          <a href="/admin/block/create?placement={ opts.placement }&redirect={ this.eden.frontend ? window.eden.mount.url : '' }" class="btn btn-sm btn-success">
            Create Block
          </a>
        </div>
      </div>
    </div>
  </div>
  <!-- / edit view -->

  <script>
    // do mixins
    this.mixin('acl');
    this.mixin('user');

    // set blocks
    this.show    = true;
    this.blocks  = (this.eden.get('blocks') || {})[opts.placement] || [];
    this.updates = new Map();

    /**
     * gets block with updates
     *
     * @param  {Object} block
     *
     * @return {Object}
     */
    renderBlock (block) {
      // check block
      if (!block || !this.updates.has(block.id)) return block;

      // create new block
      let newBlock    = Object.assign({}, block);
      let updateBlock = this.updates.get(block.id) || {}

      // set fields
      for (let key in updateBlock) {
        newBlock[key] = updateBlock[key];
      }

      // return combined block
      return newBlock;
    }

    /**
     * updates block key value
     *
     * @param  {Object} block
     * @param  {String} key
     * @param  {*}      value
     *
     * @return {*}
     */
    onUpdate (block, key, value) {
      // check has
      if (!this.updates.has(block.id)) this.updates.set(block.id, {});

      // get current value
      let val = this.updates.get(block.id);

      // set key
      val[key] = value;

      this.updates.set(block.id, val);
    }

    /**
     * toggle show]
     *
     * @param  {Event} e
     */
    onToggleQuick (e) {
      // toggles show
      e.item.block.quick = !e.item.block.quick;

      // update
      this.update();
    }

    /**
     * returns is hovered
     *
     * @return {Boolean}
     */
    isHovered () {
      // return block quick find
      return !!this.blocks.find((block) => block.quick);
    }

    /**
     * toggle show]
     *
     * @param  {Event} e
     */
    async onSaveQuick (e) {
      // toggles show
      e.item.block.saving = true;

      // set detauls
      let updates = this.updates.get(e.item.block.id) || {};

      // loop updates
      for (let key in updates) {
        // set value
        e.item.block[key] = updates[key];
      }

      // delete updates
      this.updates.delete(e.item.block.id);

      // update
      this.update();

      // send saving
      let res = await fetch('/admin/block/' + e.item.block.id + '/update', {
        'body'    : JSON.stringify(e.item.block),
        'method'  : 'post',
        'headers' : {
          'Content-Type': 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load json
      await res.text();

      // toggles show
      delete e.item.block.quick;
      delete e.item.block.saving;

      // update
      this.update();
    }

    /**
     * loads blocks
     *
     * @return {Promise}
     */
    async loadBlocks () {
      // get blocks
      let blocks = (this.eden.get('blocks') || {});

      // set blocks
      blocks[opts.placement] = [];

      // load blocks
      let res = await fetch('/blocks/' + opts.placement, {
        'method'  : 'post',
        'headers' : {
          'Content-Type': 'application/json'
        },
        'credentials' : 'same-origin'
      });

      // load json
      blocks[opts.placement] = await res.json();

      // set in eden
      this.eden.set('blocks', blocks);

      // set this.blocks
      this.blocks = blocks[opts.placement];

      // update view
      this.update();
    }

    /**
     * on mount function
     */
    this.on('update', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set blocks
      this.blocks = (this.eden.get('blocks') || {})[opts.placement] || [];

      // load blocks
      if (!(this.eden.get('blocks') || {})[opts.placement]) this.loadBlocks();
    });

    /**
     * on mount function
     */
    this.on('mount', () => {
      // check frontend
      if (!this.eden.frontend) return;

      // set blocks
      this.blocks = (this.eden.get('blocks') || {})[opts.placement] || [];

      // load blocks
      if (!(this.eden.get('blocks') || {})[opts.placement]) this.loadBlocks();
    });

  </script>
</block>
