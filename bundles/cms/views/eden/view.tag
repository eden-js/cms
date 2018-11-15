<eden-view>
  <div class="eden-blocks eden-blocks-view">
    <div ref="placement" class="block-placements" if={ !this.placing }>
      <div each={ row, x in this.rows } data-row={ x } class="row row-eq-height">
        <div each={ block, i in getBlocks(x) } data-block={ block.uuid } if={ getBlockData(block) } class={ getBlockData(block).class || 'col' } data-is="block-view-{ getBlockData(block).tag }" data={ getBlockData(block) } block={ block } on-refresh={ this.onRefreshBlock } />
      </div>
    </div>
  </div>

  <script>
    // do mixins
    this.mixin('model');

    // set update
    this.rows      = [1, 2, 3, 4, 5, 6, 7, 8];
    this.blocks    = (opts.placement || {}).render || [];
    this.loading   = {};
    this.updating  = {};
    this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});

    /**
     * gets blocks
     *
     * @param  {Integer} i
     *
     * @return {*}
     */
    getBlocks (i) {
      // check blocks
      if (!this.placement.get('blocks')) return [];
      if (!this.placement.get('placements')) return [];

      // check blocks
      let row = [];

      // get placements
      let blocks = this.placement.get('placements')[i];

      // check blocks
      if (!blocks) return [];

      // return blocks
      return blocks.map((block) => {
        // return found
        return this.placement.get('blocks').find((b) => b.uuid === block);
      }).filter((item) => item);
    }

    /**
     * get block data
     *
     * @param  {Object} block
     *
     * @return {*}
     */
    getBlockData (block) {
      // get found
      let found = this.blocks.find((b) => b.uuid === block.uuid);

      // gets data for block
      if (!found) return null;

      // return found
      return found;
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
          'data'   : data,
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
        // clone to dashboard
        data[key] = result.result[key];
      }

      // set loading
      delete block.refreshing;

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

      // set dashboard
      this.placement = opts.placement ? this.model('placement', opts.placement) : this.model('placement', {});
        
      // check blocks
      if ((this.placement.get('blocks') || []).length !== this.blocks.length) {
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
</eden-view>
