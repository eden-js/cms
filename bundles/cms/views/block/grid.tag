<block-grid>
  <block on-refresh={ opts.onRefresh } on-save={ opts.onSave } on-remove={ opts.onRemove } on-save-grid={ onSaveGrid } block={ opts.block } data={ opts.data } preview={ opts.preview } on-grid-state={ onGridState } ref="block" class="block-notes">

    <yield to="buttons">
      <button class="btn btn-sm btn-secondary" onclick={ opts.onSaveGrid }>
        <i class="fa fa-save" />
      </button>
    </yield>

    <yield to="body">
      <div class="card-body">
        <grid ref="grid" grid={ opts.data.grid } table-class="table table-bordered table-striped" title={ opts.data.title || opts.block.title } on-state={ opts.onGridState } />
      </div>
    </yield>
  </block>

  <script>
  
    /**
     * on grid state
     *
     * @param  {Object} state
     */
    async onGridState (state) {
      // set name
      this.currentState = state;
    }
    
    /**
     * on save grid state
     *
     * @param  {Event}  e
     *
     * @return {Promise}
     */
    async onSaveGrid (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set name
      opts.data.state = this.currentState;

      // do update
      await opts.onSave(opts.block, opts.data, true);
    }

  </script>
</block-grid>
