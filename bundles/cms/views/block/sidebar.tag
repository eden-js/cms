<block-sidebar>
  <div class="eden-blocks-backdrop" if={ this.showing } onclick={ hide } />
  <div class={ 'eden-blocks-sidebar' : true, 'eden-blocks-sidebar-show' : this.showing }>
    <div class="card">
      <div class="card-header">
        <h5>
          Select Block
        </h5>
        
        <ul class="nav nav-tabs card-header-tabs">
          <li class="nav-item" each={ tab, i in getTabs() }>
            <button class={ 'nav-link' : true, 'active' : isTab(tab) } onclick={ onTab }>
              { this.t('cms.category.' + tab) }
            </button>
          </li>
        </ul>
      </div>
      
      <div class="card-body">
        <div class="form-group">
          <input class="form-control" placeholder="search" type="Search" onkeyup={ onSearch } onchange={ onSearch } ref="search" />
        </div>
        <ul class="list-group">
          <li each={ block, i in getBlocks(this.tab) || [] } class={ 'list-group-item list-group-item-action flex-column align-items-start' : true, 'active' : isActive(block) } onclick={ onBlock }>
            <div class="d-flex w-100 justify-content-between">
              <h5 class="mb-1">
                { block.opts.title }
              </h5>
            </div>
            <p class="m-0">{ block.opts.description }</p>
          </li>
        </ul>
        
      </div>
      <div class="card-footer">
        <button type="button" class="btn btn-secondary float-right" onclick={ hide }>Close</button>
        <button type="button" class={ 'btn btn-primary' : true, 'disabled' : !this.type || this.loading } disabled={ !this.type || this.loading } onclick={ onAddBlock }>
          { this.loading ? 'Adding block...' : (this.type ? 'Add block' : 'Select block') }
        </button>
      </div>
    </div>
  </div>
  
  <script>
    // do i189n
    this.mixin('i18n');

    // set showing
    this.tab = 'default';
    this.showing = false;

    /**
     * Shows sidebar
     */
    show() {
      // set showing
      this.showing = true;

      // update
      this.update();
    }

    /**
     * Shows sidebar
     */
    hide() {
      // set showing
      this.showing = false;

      // update
      this.update();
    }
    
    /**
     * on block
     *
     * @param  {Event} e
     */
    onTab (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate block
      this.tab = e.item.tab;
      
      // update view
      this.update();
    }
    
    /**
     * on block
     *
     * @param  {Event} e
     */
    onBlock (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // activate block
      this.type = e.item.block.type || e.item.block.tag;
      
      // update view
      this.update();
    }

    /**
     * on block
     *
     * on search
     */
    onSearch(e) {
      // check search
      this.search = this.refs.search.value;
      
      // update view
      this.update();
    }

    /**
     * on block
     *
     * @param  {Event} e
     */
    async onAddBlock (e) {
      // prevent default
      e.preventDefault();
      e.stopPropagation();
      
      // set loading
      this.loading = true;
      
      // update view
      this.update();
      
      // add block by type
      await opts.addBlock(this.type);
      
      // set loading
      this.type    = null;
      this.loading = false;
      
      // close modal
      this.hide();
    }

    /**
     * gets tabs
     */
    getTabs() {
      // return categories
      return (opts.blocks || []).reduce((accum, block) => {
        // loop categories
        (block.opts.categories || []).forEach((category) => {
          // add category
          if (!accum.includes(category)) accum.push(category);
        });

        // return accumulator
        return accum;
      }, ['default']);
    }
  
    /**
     * gets blocks
     *
     * @return {*}
     */
    getBlocks (category = 'default') {
      // return sorted blocks
      let rtn = (opts.blocks || []).sort((a, b) => {
        // Return sort
        return ('' + a.opts.title).localeCompare(b.opts.title);
      });
      
      // check default
      if (category !== 'default') {
        rtn = rtn.filter((block) => {
          // set category
          return (block.opts.categories || []).includes(category);
        });
      } else {
        rtn = rtn.filter((block) => {
          // check categories
          return !(block.opts.categories);
        });
      }

      // do block search
      if (this.search && this.search.length) rtn = rtn.filter((block) => {
        // check search
        return ('' + block.opts.title).toLowerCase().includes(this.search.toLowerCase());
      });
      
      // return rtn
      return rtn;
    }
    
    /**
     * on is active
     *
     * @param  {Object}  block
     *
     * @return {Boolean}
     */
    isTab (tab) {
      // return type
      return this.tab === tab;
    }
    
    /**
     * on is active
     *
     * @param  {Object}  block
     *
     * @return {Boolean}
     */
    isActive (block) {
      // return type
      return this.type === block.type;
    }
    
  </script>
</block-sidebar>
