<{include file="db:countdown_header.tpl"}>
<div class="panel panel-info">

    <h5><strong><{$smarty.const._MD_COUNTDOWN_EVENTS}></strong></h5>
    <table id="events" class="table table-striped">
        <thead>
        <tr>

            <th><{$smarty.const._MD_COUNTDOWN_EVENTS}></th>

        </tr>
        </thead>
            <tbody>
        <{foreach item=events from=$events}>
            <tr>
                <td>
				#<{$events.id}>	<{*<{$events.uid}>*}><br>


				<img src="<{$xoops_url}>/uploads/countdown/images/<{$events.logo}>" alt="<{$events.name}>" title="<{$events.name}>" class="img-fluid"><br>
     
				<strong><{$smarty.const._MD_COUNTDOWN_EVENTS_NAME}></strong>   <br>        
					<a href="event.php?id=<{$events.id}>"><{$events.name}></a>
				<br>
				<strong> <{$smarty.const._MD_COUNTDOWN_EVENTS_DESCRIPTION}> </strong><br>            
					<{$events.description}>
				<br>
				<strong><{$smarty.const._MD_COUNTDOWN_EVENTS_DATE}> </strong><br>
						<{$events.date}>
                <br>
				<strong><{$smarty.const._MD_COUNTDOWN_TIME_REMAINING}> </strong><br>
               <div id="timer<{$events.id}>" class="timer">
<!--  Timer Component  -->
  <Timer 
         starttime="<{$smarty.now|date_format:"%Y-%m-%d %H:%M:%S"}>" 
         endtime="<{$events.dateiso}>" 
         trans='{  
         "day":"Day",
         "hours":"Hours",
         "minutes":"Minuts",
         "seconds":"Seconds",
         "expired":"Event has been expired.",
         "running":"Till the end of event.",
         "upcoming":"Till start of event.",
         "status": {
            "expired":"Expired",
            "running":"Running",
            "upcoming":"Future"
           }}'
         ></Timer>
<!--  End! Timer Component  -->
</div>


<script>
 Vue.component('Timer',{
	template: `
  	<div>
      <div class="day">
        <span class="number">{{ days }}</span>
        <div class="format">{{ wordString.day }}</div>
      </div>
      <div class="hour">
        <span class="number">{{ hours }}</span>
        <div class="format">{{ wordString.hours }}</div>
      </div>
      <div class="min">
        <span class="number">{{ minutes }}</span>
        <div class="format">{{ wordString.minutes }}</div>
      </div>
      <div class="sec">
        <span class="number">{{ seconds }}</span>
        <div class="format">{{ wordString.seconds }}</div>
      </div>
      <div class="message">{{ message }}</div>
      <div class="status-tag" :class="statusType">{{ statusText }}</div>
    </div>
  `,
  props: ['starttime','endtime','trans'] ,
  data: function(){
  	return{
    	timer:"",
      wordString: {},
      start: "",
      end: "",
      interval: "",
      days:"",
      minutes:"",
      hours:"",
      seconds:"",
      message:"",
      statusType:"",
      statusText: "",
    
    };
  },
  created: function () {
        this.wordString = JSON.parse(this.trans);
    },
  mounted(){
    this.start = new Date(this.starttime).getTime();
    this.end = new Date(this.endtime).getTime();
    // Update the count down every 1 second
    this.timerCount(this.start,this.end);
    this.interval = setInterval(() => {
        this.timerCount(this.start,this.end);
    }, 1000);
  },
  methods: {
    timerCount: function(start,end){
        // Get todays date and time
        var now = new Date().getTime();

        // Find the distance between now an the count down date
        var distance = start - now;
        var passTime =  end - now;

        if(distance < 0 && passTime < 0){
            this.message = this.wordString.expired;
            this.statusType = "expired";
            this.statusText = this.wordString.status.expired;
            clearInterval(this.interval);
            return;

        }else if(distance < 0 && passTime > 0){
            this.calcTime(passTime);
            this.message = this.wordString.running;
            this.statusType = "running";
            this.statusText = this.wordString.status.running;

        } else if( distance > 0 && passTime > 0 ){
            this.calcTime(distance); 
            this.message = this.wordString.upcoming;
            this.statusType = "upcoming";
            this.statusText = this.wordString.status.upcoming;
        }
    },
    calcTime: function(dist){
      // Time calculations for days, hours, minutes and seconds
        this.days = Math.floor(dist / (1000 * 60 * 60 * 24));
        this.hours = Math.floor((dist % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        this.minutes = Math.floor((dist % (1000 * 60 * 60)) / (1000 * 60));
        this.seconds = Math.floor((dist % (1000 * 60)) / 1000);
    }
    
  }
});

new Vue({
  el: "#timer<{$events.id}>",
});
</script>

                <br>
                    <{if $xoops_isadmin == true}>
                        <a href="admin/events.php?op=edit&id=<{$events.id}>" title="<{$smarty.const._EDIT}>"><img src="<{xoModuleIcons16 edit.png}>" alt="<{$smarty.const._EDIT}>" title="<{$smarty.const._EDIT}>"/></a>
                        &nbsp;
                        <a href="admin/events.php?op=delete&id=<{$events.id}>" title="<{$smarty.const._DELETE}>"><img src="<{xoModuleIcons16 delete.png}>" alt="<{$smarty.const._DELETE}>" title="<{$smarty.const._DELETE}>"</a>
                    <{/if}>
					
					 <p class="text-muted"><span class="fa fa-calendar"></span>
                                                        <{if $events.date_created == $events.date_updated}>
                                                            <small><{$events.date_created|date_format}></small>
                                                        <{else}>
                                                            <small><{$events.date_updated|date_format}></small>
                                                        <{/if}>
														<span class="fa fa-user-circle-o"></span> <{$events.postername}> <span class="fa fa-tag"></span> <{$events.category}>
                      </p>
					
					
                </td>
            </tr>
		<{/foreach}> 
	 </tbody>
     </table>
</div>
<{$pagenav}>
<{$commentsnav}> <{$lang_notice}>
<{if $comment_mode == "flat"}> <{include file="db:system_comments_flat.tpl"}> <{elseif $comment_mode == "thread"}> <{include file="db:system_comments_thread.tpl"}> <{elseif $comment_mode == "nest"}> <{include file="db:system_comments_nest.tpl"}> <{/if}>
<{include file="db:countdown_footer.tpl"}>

  <script>
                                $(document).ready(function () {
                                    $('#events').DataTable({
                                        "ordering": false,
                                        "lengthChange": false,
                                        "displayLength": <{$eventperpage}>,
                                        "language": {
                                            "decimal": "<{$smarty.const._MD_COUNTDOWN_DTABLE_DECIMAL}>",
                                            "emptyTable": "<{$smarty.const._MD_COUNTDOWN_DTABLE_EMPTYTABLE}>",
                                            "info": "<{$smarty.const._MD_COUNTDOWN_DTABLE_INFOSHOWING}> _START_ <{$smarty.const._MD_COUNTDOWN_DTABLE_INFOTO}> _END_ <{$smarty.const._MD_COUNTDOWN_DTABLE_INFOOF}> _TOTAL_ <{$smarty.const._MD_COUNTDOWN_DTABLE_INFOENTRIES}>",
                                            "infoEmpty": "<{$smarty.const._MD_COUNTDOWN_DTABLE_INFOEMPTY}>",
                                            "infoFiltered": "(<{$smarty.const._MD_COUNTDOWN_DTABLE_INFOFILTEREDFROM}> _MAX_ <{$smarty.const._MD_COUNTDOWN_DTABLE_INFOFILTEREDTOTALENTRIES}>)",
                                            "infoPostFix": "<{$smarty.const._MD_COUNTDOWN_DTABLE_INFOPOSTFIX}>",
                                            "thousands": "<{$smarty.const._MD_COUNTDOWN_DTABLE_THOUSANDS}>",
                                            "lengthMenu": "<{$smarty.const._MD_COUNTDOWN_DTABLE_LENGTHMENUSHOW}> _MENU_ <{$smarty.const._MD_COUNTDOWN_DTABLE_LENGTHMENUENTRIES}>",
                                            "loadingRecords": "<{$smarty.const._MD_COUNTDOWN_DTABLE_LOADINGRECORDS}>",
                                            "processing": "<{$smarty.const._MD_COUNTDOWN_DTABLE_PROCESSING}>",
                                            "search": "<{$smarty.const._MD_COUNTDOWN_DTABLE_SEARCH}>",
                                            "zeroRecords": "<{$smarty.const._MD_COUNTDOWN_DTABLE_ZERORECORDS}>",
                                            "paginate": {
                                                "first": "<{$smarty.const._MD_COUNTDOWN_DTABLE_FIRST}>",
                                                "last": "<{$smarty.const._MD_COUNTDOWN_DTABLE_LAST}>",
                                                "next": "<{$smarty.const._MD_COUNTDOWN_DTABLE_NEXT}>",
                                                "previous": "<{$smarty.const._MD_COUNTDOWN_DTABLE_PREVIOUS}>"
                                            },
                                            "aria": {
                                                "sortAscending": "<{$smarty.const._MD_COUNTDOWN_DTABLE_SORT_ASCENDING}>",
                                                "sortDescending": "<{$smarty.const._MD_COUNTDOWN_DTABLE_SORT_DESCENSING}>"
                                            }
                                        }
                                    });
                                });
                            </script>