import dash
import dash_core_components as dcc
import copy
import dash_html_components as html
from datetime import datetime
import pandas as pd
import scipy
from dash.dependencies import Input, Output, State, Event
import dash_core_components as dcc
import dash_html_components as html
import dash_table_experiments as dt
import plotly
import flask
import copy
import numpy as np
import plotly.plotly as py
import plotly.graph_objs as go
from datetime import datetime
import plotly.figure_factory as ff


## load data /WA_Income_Sum_Bill.csv
mix_wasum_bill = pd.read_csv('Census_Data/WA_Income_Sum_Bill.csv')
li_name = ['bill', 'percentFixed', 'percentVariable', 'service_charge', 'variable_charge']
colors = {'bill':['blue', 'Total Bill (USD)','y'], 'percentFixed':['orange','Fixed Price Bill (%)','y2'],
          'percentVariable':['blue','Variable Price Bill (%)','y3'], 'service_charge':['orange','Service Charge (USD)','y4'],
          'variable_charge':['orange','Variable Charge (USD)','y5'],}
mix_wasum_bill['percentVariable'] = 1 - mix_wasum_bill['percentFixed']
mix_wasum_bill['variable_charge'] = mix_wasum_bill['bill'] - mix_wasum_bill['service_charge']

re_tot_2017 = mix_wasum_bill
name_seas = {'_17_tot_autumn':['Autumn 2016','#DA6605'],
               '_17_tot_winter':['Winter 2017','rgb(44,123,182)'],
               '_17_tot_spring':['Spring 2017','green'],
               '_17_tot_summer':['Summer 2017','orange']}
by_tim_seas = ['_17_mean_autumn',
               '_17_mean_winter',
               '_17_mean_spring',
               '_17_mean_summer']
by_tim_tot = ['_17_tot_autumn',
               '_17_tot_winter',
               '_17_tot_spring',
               '_17_tot_summer']

#1 Plot Code
#[u'Autumn 2016', u'Winter 2017', u'Spring 2017', u'Summer 2017']
by_tim_seas
test = re_tot_2017['report_pwsid'],
data = []
for s in by_tim_tot:
    trace0 = go.Box(
        y = re_tot_2017['Residential_Production'+s]/re_tot_2017['Target_Production'+s],
        name = name_seas[s][0],
        jitter = 0.3,
        pointpos = -1.8,
        boxpoints = 'all',
        hoverinfo =  'customdata',
        #hoverinfosrc = 'customdata',
        customdata = re_tot_2017['report_pwsid'],

        marker = dict(
            color = name_seas[s][1],
            opacity=0.5,
            line= dict(width=1),),
        line = dict(
            color = name_seas[s][1])
    )
    data.append(trace0)


layout = go.Layout(
    title = "Water Efficiency by Season",
    legend=dict(orientation="h", x=0.11, y=1.1,),
    #width=1000,
    height=500,
)

fig1 = go.Figure(data=data,layout=layout)


def get_seasons_1(theseas):
    by_tim_seas
    test = re_tot_2017['report_pwsid'],
    data = []
    for s in theseas:
        trace0 = go.Box(
            y=re_tot_2017['Residential_Production' + s] / re_tot_2017['Target_Production' + s],
            name=name_seas[s][0],
            jitter=0.3,
            pointpos=-1.8,
            boxpoints='all',
            hoverinfo='customdata',
            # hoverinfosrc = 'customdata',
            customdata=re_tot_2017['report_pwsid'],
            marker=dict(
                color=name_seas[s][1],
                opacity=0.5,
                line=dict(width=1), ),
            line=dict(
                color=name_seas[s][1])
        )
        data.append(trace0)

    layout = go.Layout(
        title="Water Efficiency by Season",
        legend=dict(orientation="h", x=0.11, y=1.1, ),
        # width=1000,
        height=500,
    )

    fig1 = go.Figure(data=data, layout=layout)
    return fig1

#2 Plot Code

def LSI(s):
    x1 = re_tot_2017['Residential_Production' + s] / re_tot_2017['Target_Production' + s]
    return x1


def the_names(s):
    l1 = name_seas[s][0]
    return l1


def the_text(s):
    l0 = re_tot_2017.PWSID + ' - ' + re_tot_2017.report_agency_name
    return l0


def the_color(s):
    c = name_seas[s][1]
    return c


col = []
hist_data = []
group_labels = []
rug_text_all = []

count = 0
for s in by_tim_tot:
    hist_data.append(LSI(s))
    group_labels.append(the_names(s))
    rug_text_all.append(the_text(s))
    col.append(the_color(s))

# , colors=colors,

# Create distplot with curve_type set to 'normal'
fig2 = ff.create_distplot(hist_data, group_labels, show_hist=False, rug_text=rug_text_all, bin_size=.1, colors=col, histnorm='probability')

fig2['layout'].update(title='Water Consumption Efficiency Distribution',
                      height=500,
                      showlegend=True,
                      legend=dict(orientation="h", x=0.05, y=1.1, ),
                      shapes=[dict({
                          'type': 'line',
                          'x0': 1,
                          'y0': 0,
                          'x1': 1,
                          'y1': 0.16,
                          'line': {
                              'color': 'lightgrey',
                              'width': 2
                          }})],
                      annotations=[
                          dict(
                              x=1,
                              y=0.135,
                              xref='x',
                              yref='y',
                              text='Efficiency Goal',
                              arrowcolor='lightgrey',
                              opacity=.8,

                              showarrow=True,
                              arrowhead=7,
                              ax=60,
                              ay=-35
                          )],

                      plot_bgcolor='rgb(250,250,250)',
                      xaxis=dict(title='Water Consumption Efficiency', gridcolor='#FFFFFF',  # gridwidth=2
                                 ),
                      yaxis=dict(title='Water Districts Count', gridcolor='#FFFFFF',
                                 tickmode='array',
                                 tickvals=list(np.linspace(0, .16, 9)),
                                 ticktext=[round(i,0) for i in list(np.linspace(0, .16, 9)*re_tot_2017.shape[0])],

                                 ))


def get_seasons_2(theseas):
    def LSI(s):
        x1 = re_tot_2017['Residential_Production'+s]/re_tot_2017['Target_Production'+s]
        return x1

    def the_names(s):
        l1 = name_seas[s][0]
        return l1

    def the_text(s):
        l0 = re_tot_2017.PWSID + ' - ' + re_tot_2017.report_agency_name
        return l0

    def the_color(s):
        c = name_seas[s][1]
        return c


    col = []
    hist_data = []
    group_labels = []
    rug_text_all = []

    count=0
    for s in theseas:
        hist_data.append(LSI(s))
        group_labels.append(the_names(s))
        rug_text_all.append(the_text(s))
        col.append(the_color(s))

    #, colors=colors,

    # Create distplot with curve_type set to 'normal'
    fig2 = ff.create_distplot(hist_data, group_labels, show_hist=False, rug_text = rug_text_all, bin_size=.1, colors=col, histnorm='probability')

    fig2['layout'].update(title='Water Consumption Efficiency Distribution',
                          height = 500,
                         showlegend=True,
                          legend=dict(orientation="h", x=0.05, y=1.1,),
                         shapes=[dict({
                                'type': 'line',
                                'x0': 1,
                                'y0': 0,
                                'x1': 1,
                                'y1': 0.16,
                                'line': {
                                    'color': 'lightgrey',
                                    'width': 2
                                }})],
                         annotations=[
                                dict(
                                    x=1,
                                    y=0.135,
                                    xref='x',
                                    yref='y',
                                    text='Efficiency Goal',
                                    arrowcolor = 'lightgrey',
                                    opacity = .8,

                                    showarrow=True,
                                    arrowhead=7,
                                    ax=60,
                                    ay=-35
                                )],

                         plot_bgcolor='rgb(250,250,250)',
                        xaxis = dict(title = 'Water Consumption Efficiency',gridcolor='#FFFFFF',#gridwidth=2
                                    ),
                  yaxis = dict(title = 'Water Districts Count', gridcolor='#FFFFFF',
                                 tickmode='array',
                                 tickvals=list(np.linspace(0, .16, 9)),
                                 ticktext=[round(i,0) for i in list(np.linspace(0, .16, 9)*re_tot_2017.shape[0])],

                              ))
    return fig2
#3 Plot Code
s_tot_2017= pd.read_csv('Census_Data/Water_District_Income_2017.csv')
listforcolors = [ u'$15,000 to $19,999',
  u'$20,000 to $24,999',
  u'$25,000 to $29,999',
  u'$30,000 to $34,999',
  u'$35,000 to $39,999',
  u'$40,000 to $44,999',
  u'$45,000 to $49,999',
  u'$50,000 to $59,999',
  u'$60,000 to $74,999',
  u'$75,000 to $99,999',
  u'$100,000 to $124,999',
  u'$125,000 to $149,999',
  u'$150,000 to $199,999',
  u'$200,000 or more',]

s = '_17_tot_summer'
data = []
the_c = 0
for s in by_tim_tot:
    if the_c == 3:
        vis_bool = True
    else:
        vis_bool = False

    for i in listforcolors:
        # i=  listforcolors[5]
        trace_actual = go.Scatter(x=s_tot_2017[s_tot_2017['Medium'] == i]['x_medium'],
                                  y=s_tot_2017[s_tot_2017['Medium'] == i]['Residential_Production' + s] /
                                    s_tot_2017[s_tot_2017['Medium'] == i]['Target_Production' + s],
                                  visible=vis_bool,
                                  text=s_tot_2017[s_tot_2017['Medium'] == i]['PWSID'] + ' - ' +
                                       s_tot_2017[s_tot_2017['Medium'] == i]['report_agency_name'],
                                  name='Water Performance' + name_seas[s][0] + 'w/ Household Median Income',
                                  marker=dict(size=16,
                                              cmax=13,
                                              cmin=0,
                                              color=s_tot_2017[s_tot_2017['Medium'] == i].color.tolist(),
                                              line=dict(width=1),
                                              colorscale='Jet', ),
                                  mode='markers',
                                  opacity=.55, )
        data.append(trace_actual)
    the_c += 1

menu = []
other = []
vis = []

for s in by_tim_tot:
    for i in listforcolors:
        vis.append(False)
        other.append(True)
count = 0

for s in by_tim_tot:
    use_vis = copy.deepcopy(vis)
    for i in listforcolors:
        use_vis[count] = True
        count += 1
    menu.append(dict(label=name_seas[s][0],
                     method='update',
                     args=[{'visible': use_vis}]))

updatemenus2 = list([
    dict(active=3,
         buttons=list(menu),
         pad={'r': 20, 't': 20},
         x=1,
         xanchor='right',
         yanchor='top',
         ),

])

layout = dict(title='Water Seasonal Performance in 2017 w/ Household Median Income', showlegend=False,
              # width=900,
              height=550,
              shapes=[dict({
                  'type': 'line',
                  'x0': -.5,
                  'y0': 1,
                  'x1': 13.5,
                  'y1': 1,
                  'line': {
                      'color': 'lightgrey',
                      'width': 2
                  }})],
              annotations=[
                  dict(
                      x=-.5,
                      y=1,
                      xref='x',
                      yref='y',
                      text='Efficiency Goal',
                      arrowcolor='lightgrey',
                      opacity=.8,

                      showarrow=True,
                      arrowhead=7,
                      ax=100,
                      ay=-200
                  )],
              hovermode='closest',
              yaxis=dict(
                  # range=[0, 28000000000],
                  title='Water Consumption Efficiency',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),
              xaxis=dict(
                  # range=[0, 28000000000],
                  title='Median Household Income',

                  # tickvals = range(0,13),
                  # ticktext = listforcolors,
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'

                  ),
              ),
              updatemenus=updatemenus2)

fig3 = dict(data=data, layout=layout)

sup= pd.read_csv('Census_Data/Water_District_Historical.csv')
sup['report_date'] = pd.to_datetime(sup.report_date)

def create_time_series(test, name):
    trace_actual = go.Scatter(x=sup[sup.report_pwsid == test].sort_values('report_date')['report_date'],
                        y=sup[sup.report_pwsid == test].sort_values('report_date')['Residential_Production'],
                        visible=True,
                        text=  test,# + ' - ' + sup[sup.report_pwsid ==test]['report_agency_name'],
                        name='Real Residential Production',
                        line=dict(color='#33CFA5'))
    trace_target = go.Scatter(x=sup[sup.report_pwsid == test].sort_values('report_date')['report_date'],
                               y=sup[sup.report_pwsid == test].sort_values('report_date')['Target_Production'],
                               name='Efficiency Goal',
                               text=  test,# + ' - ' + sup[sup.report_pwsid == test]['report_agency_name'],
                               visible=True,
                               line=dict(color='#F06A6A', dash='dash'))
    data = [trace_actual, trace_target]


    updatemenus = list([
        dict(active=0,
             buttons=list([
                dict(label = 'Both',
                     method = 'update',
                     args = [{'visible': [True, True]},]),
                             #{'title': 'Both',}]),
                dict(label = 'Actual',
                     method = 'update',
                     args = [{'visible': [True, False]},]),
                             #{'title': 'Actual',}]),
                dict(label = 'Target',
                     method = 'update',
                     args = [{'visible': [False, True]},]),
                             #{'title': 'Target'}]),
            ]),
        )
    ])

    layout = dict(title='Water Performance: ' + test+ ' - ' + name, showlegend=True,
                  yaxis=dict(
            title='Total Gallons',
            titlefont=dict(
                family='Arial, sans-serif',
                size=18,
                color='lightgrey'
            ),
        ), updatemenus=updatemenus)

    fig5 = dict(data=data, layout=layout)
    return fig5

test ='CA4110016'
#test ='CA1510003'

trace_actual = go.Scatter(x=sup[sup.report_pwsid == test].sort_values('report_date')['report_date'],
                        y=sup[sup.report_pwsid == test].sort_values('report_date')['Residential_Production'],
                        visible=True,
                        text=  test,# + ' - ' + sup[sup.report_pwsid ==test]['report_agency_name'],
                        name='Real Residential Production',
                        line=dict(color='#33CFA5'))
trace_target = go.Scatter(x=sup[sup.report_pwsid == test].sort_values('report_date')['report_date'],
                           y=sup[sup.report_pwsid == test].sort_values('report_date')['Target_Production'],
                           name='Efficiency Goal',
                           text=  test,# + ' - ' + sup[sup.report_pwsid == test]['report_agency_name'],
                           visible=True,
                           line=dict(color='#F06A6A', dash='dash'))
data = [trace_actual, trace_target]


updatemenus = list([
    dict(active=0,
         buttons=list([
            dict(label = 'Both',
                 method = 'update',
                 args = [{'visible': [True, True]},
                         {'title': 'Both',}]),
            dict(label = 'Actual',
                 method = 'update',
                 args = [{'visible': [True, False]},
                         {'title': 'Actual',}]),
            dict(label = 'Target',
                 method = 'update',
                 args = [{'visible': [False, True]},
                         {'title': 'Target'}]),
        ]),
    )
])

layout = dict(title='Water Performance: ' + test, showlegend=True,
              yaxis=dict(
        title='Total Gallons',
        titlefont=dict(
            family='Arial, sans-serif',
            size=18,
            color='lightgrey'
        ),
    ), updatemenus=updatemenus)

fig5 = dict(data=data, layout=layout)

### for plot6
forscale = []
for i in listforcolors:
    forscale.append(s_tot_2017[s_tot_2017['Medium'] == i].x_medium.unique()[0])
forscale

tryT = s_tot_2017.color.unique().tolist()
tryT.sort()
tryT

op4 = {}
for i in range(len(re_tot_2017)):
    op4[re_tot_2017.loc[i, 'PWSID']] = re_tot_2017.loc[i, 'report_agency_name']

op2 = []
for i in re_tot_2017.PWSID.sort_values():
    op2.append({'label': i + ' - ' + op4[i], 'value': i})
op3 = []
for i in re_tot_2017.report_agency_name.sort_values():
    op3.append({'label': i, 'value': i})

prev = ''
prev2 = ''
# 6  Plot Code
# Plot Bill vs Sumer Mean Water Consumption/perCap
data = []
visshow = True
for i in li_name:
    trace_actual = go.Scatter(x=mix_wasum_bill.Residential_Production_17_mean_summer / mix_wasum_bill.report_population,
                              y=mix_wasum_bill[i],
                              visible=visshow,
                              text=mix_wasum_bill['PWSID'] + ' - ' + mix_wasum_bill['report_agency_name'],
                              name=colors[i][1],
                              marker=dict(size=16,
                                          # color = colors[i][0],
                                          line=dict(width=1),
                                          colorbar=dict(
                                              title='Median Household Income',
                                              bordercolor='lightgrey',
                                              outlinecolor='lightgrey',
                                              ticktext=forscale,
                                              tickmode='array',
                                              tickvals=tryT,
                                          ),
                                          cmax=13,
                                          cmin=0,
                                          color=mix_wasum_bill.color.tolist(),
                                          colorscale='Jet', ),
                              opacity=.55,
                              mode='markers')
    data.append(trace_actual)
    visshow = False

menu = []
base = [False, False, False, False, False]

count = 0
for i in li_name:
    vis = copy.copy(base)
    vis[count] = True
    menu.append(dict(label=colors[i][1],
                     method='update',
                     args=[{'visible': vis, 'yaxis': colors[i][2]}]
                     ))
    count += 1

updatemenus2 = list([
    dict(active=0,
         buttons=list(menu),
         x=0.15,
         xanchor='left',
         y=1.08,
         yanchor='top',
         )
])

layout = dict(title='Calculated Bill (15 ccf) vs Sumer Mean Consumption/perCap', showlegend=False,
              margin=dict(pad=-50, t=-5),
              # shapes = line_1,
              width=900,
              height=700,
              # paper_bgcolor ='lightgrey',
              plot_bgcolor='rgb(240,240,240)',

              hovermode='closest',
              yaxis=dict(
                  autorange=True,
                  visible=True,
                  title='Bill (USD)',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              yaxis2=dict(
                  autorange=True,
                  visible=True,
                  title='Fixed Price Bill (%)',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),
              yaxis3=dict(
                  autorange=True,
                  visible=True,
                  title=colors['percentVariable'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              yaxis4=dict(
                  autorange=True,
                  visible=True,
                  title=colors['service_charge'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),
              yaxis5=dict(
                  autorange=True,
                  visible=True,
                  title=colors['variable_charge'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              xaxis=dict(
                  autorange=True,
                  # range=[0, 28000000000],
                  title='Real Total Gallons',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'

                  ),
              ),

              updatemenus=updatemenus2,
              )

annotations = list([
    dict(text='Price Variable:', x=-10, y=1.07, yref='paper', align='left', showarrow=False)
])
layout['annotations'] = annotations

fig6 = dict(data=data, layout=layout)

# 7  Plot Code
# Plot Bill vs Sumer Mean Water Consumption/perCap
data = []
visshow = True
for i in li_name:
    trace_actual = go.Scatter(x=mix_wasum_bill.Residential_Production_17_tot_summer / mix_wasum_bill.Target_Production_17_tot_summer,
                              y=mix_wasum_bill[i],
                              visible=visshow,
                              text=mix_wasum_bill['PWSID'] + ' - ' + mix_wasum_bill['report_agency_name'],
                              name=colors[i][1],
                              marker=dict(size=16,
                                          # color = colors[i][0],
                                          line=dict(width=1),
                                          colorbar=dict(
                                              title='Median Household Income',
                                              bordercolor='lightgrey',
                                              outlinecolor='lightgrey',
                                              ticktext=forscale,
                                              tickmode='array',
                                              tickvals=tryT,
                                          ),
                                          cmax=13,
                                          cmin=0,
                                          color=mix_wasum_bill.color.tolist(),
                                          colorscale='Jet', ),
                              opacity=.55,
                              mode='markers')
    data.append(trace_actual)
    visshow = False

menu = []
base = [False, False, False, False, False]

count = 0
for i in li_name:
    vis = copy.copy(base)
    vis[count] = True
    menu.append(dict(label=colors[i][1],
                     method='update',
                     args=[{'visible': vis, 'yaxis': colors[i][2]}]
                     ))
    count += 1

updatemenus2 = list([
    dict(active=0,
         buttons=list(menu),
         x=0.15,
         xanchor='left',
         y=1.08,
         yanchor='top',
         )
])

layout = dict(title='Calculated Bill (15 ccf) vs Sumer Mean Consumption/perCap', showlegend=False,
              margin=dict(pad=-50, t=-5),
              # shapes = line_1,
              width=900,
              height=700,
              # paper_bgcolor ='lightgrey',
              plot_bgcolor='rgb(240,240,240)',

              hovermode='closest',
              yaxis=dict(
                  autorange=True,
                  visible=True,
                  title='Bill (USD)',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              yaxis2=dict(
                  autorange=True,
                  visible=True,
                  title='Fixed Price Bill (%)',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),
              yaxis3=dict(
                  autorange=True,
                  visible=True,
                  title=colors['percentVariable'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              yaxis4=dict(
                  autorange=True,
                  visible=True,
                  title=colors['service_charge'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),
              yaxis5=dict(
                  autorange=True,
                  visible=True,
                  title=colors['variable_charge'][1],
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'
                  ), ),

              xaxis=dict(
                  autorange=True,
                  title='Water Production Efficiency',
                  titlefont=dict(
                      family='Arial, sans-serif',
                      size=18,
                      color='lightgrey'

                  ),
              ),

              updatemenus=updatemenus2,
              )

annotations = list([
    dict(text='Price Variable:', x=0, y=1.07, yref='paper', align='left', showarrow=False)
])
layout['annotations'] = annotations

fig7 = dict(data=data, layout=layout)

thedcitnames = {}
for i in re_tot_2017.PWSID:
    thedcitnames[i] = re_tot_2017[re_tot_2017.PWSID == i]['report_agency_name'].unique().tolist()

boostrap = 'https://cdn.rawgit.com/plotly/dash-app-stylesheets/2d266c578d2a6e8850ebce48fdb52759b2aef506/stylesheet-oil-and-gas.css'
app = dash.Dash(__name__)
server = app.server
app.css.append_css({'external_url': boostrap})

app.layout = html.Div(children=[
    # title 1
    html.H1(children='California Water Districts Performance', className='row'),

    # First Control
    html.Div([
        html.Div(
            [
                html.P('Choose Water District ID:'),
                dcc.Dropdown(
                    id='WA_id',
                    options=op2,
                    multi=False,
                    value='CA3910012',
                ),
            ],
            className='six columns',
            style={'margin-top': '10'},
        ),
        html.Div(
            [
                html.P('Choose Water District Name:'),
                dcc.Dropdown(
                    id='WA_name',
                    options=op3,
                    multi=False,
                    value='Stockton  City of',
                ),
            ],
            className='six columns',
            style={'margin-top': '10', 'display': 'none'},
        ),
    ], className='row', ),

    # Second Control
    html.Div([
        html.Div(
            [
                html.P('Choose Season:'),
                dcc.Checklist(
                    id='Season',
                    options=[
                        {'label': 'Autumn 2016', 'value': '_17_tot_autumn'},
                        {'label': 'Winter 2017', 'value': '_17_tot_winter'},
                        {'label': 'Spring 2017', 'value': '_17_tot_spring'},
                        {'label': 'Summer 2017', 'value': '_17_tot_summer'},
                    ],
                    values=['_17_tot_autumn', '_17_tot_winter', '_17_tot_spring', '_17_tot_summer'],
                    style={'padding-left': 140, 'padding': 0, 'color': '#0C0C0C', 'background-color': '#33C3F0',
                           'border-color': '#898989'},
                    labelStyle={'display': 'inline-block', 'padding-left': 165}, ),
            ],
            className='12 columns',
            style={'margin-top': '10'},
        )
    ], className='row', ),

    # First row
    html.Div([
        html.Div([
            html.Div(),
            dcc.Graph(id='graph1',
                      figure=fig1, ), ], className='six columns',  # style={'margin-top': '10'}
        ),
        html.Div([
            html.Div(),
            dcc.Graph(id='graph2',
                      figure=fig2, ), ], className='six columns',  # style={'margin-top': '10'}
        ),
    ], className='row', ),
    ## Hidden values
    html.Div(id='h1', style={'display': 'none'}),
    html.Div(id='h2', style={'display': 'none'}),
    html.Div(id='h3', style={'display': 'none'}),
    # Second row
    html.Div([
        html.Div([
            html.Div(),
            dcc.Graph(id='graph3',
                      figure=fig3, ), ], className='six columns',  # style={'margin-top': '10'}
        ),
        html.Div([
            html.Div(),
            dcc.Graph(id='graph4',
                      figure=fig6, ), ], className='six columns',  # style={'margin-top': '10'}
        ),
    ], className='row', ),

    # Title2 row
    html.H2(children='Water Districts Time-series Performance',
            style={'padding': 0, 'color': '#0C0C0C', 'background-color': '#DADADA',
                   'border-color': '#898989'}, className='row'),
    # Third row
    html.Div([
        html.Div([
            html.Div(),
            dcc.Graph(id='graph5',
                      figure=fig5, ), ], className='twelve columns',  # style={'margin-top': '10'}
        ),
    ], className='row', ),

    # 4th row
    html.Div([
        html.Div([
            html.Div(),
            dcc.Graph(id='graph7',
                      figure=fig7, ), ], className='six columns',  # style={'margin-top': '10'}
        ),
    ], className='row', ),

], className="ten columns offset-by-one")


# Callback CLick to box
@app.callback(
    dash.dependencies.Output('WA_id', 'value'),
    [dash.dependencies.Input('graph2', 'clickData'), dash.dependencies.Input('graph3', 'clickData')],
    # dash.dependencies.Input('WA_name', 'value')],
    [dash.dependencies.State('WA_id', 'value'), dash.dependencies.State('h1', 'children'),
     dash.dependencies.State('h2', 'children')])
def update_box_WA_ID(hoverData, hoverData2, x1, z1, z2):
    # print x1, 'previous'
    # print z1, 'hidden var 1'
    # print z2, 'hidden var 2'
    #     if x1!= name:
    #         return name
    if type(hoverData) == dict:
        h1 = hoverData['points'][0]['text']
        y1 = h1[:h1.find(' - ')]
    else:
        y1 = 'no'

    if type(hoverData2) == dict:
        h2 = hoverData2['points'][0]['text']
        y2 = h2[:h2.find(' - ')]
    else:
        y2 = 'no'

    # print y1, 'h1 from click'
    # print y2, 'h2 from click'

    if (y1 == 'no') & (y2 == 'no'):
        # print 'returned:', x1
        return x1
    if y1 == 'no':
        # print 'returned:', y2
        return y2
    if y2 == 'no':
        # print 'returned:', y1
        return y1

    if z1 == y1:
        return y2

    if z2 == y2:
        return y1


# Callback box to timeseries
@app.callback(
    dash.dependencies.Output('graph5', 'figure'),
    [dash.dependencies.Input('WA_id', 'value'), dash.dependencies.Input('WA_name', 'value')])
def update_x_timeseries(x, y):
    name = y
    return create_time_series(x, name)


# Callback season to boxplot
@app.callback(
    dash.dependencies.Output('graph1', 'figure'),
    [dash.dependencies.Input('Season', 'values')])
def season_selector(x):
    # print x
    return get_seasons_1(x)


# Callback season to boxplot
@app.callback(
    dash.dependencies.Output('graph2', 'figure'),
    [dash.dependencies.Input('Season', 'values')])
def season_selector2(x):
    # print x
    return get_seasons_2(x)


# Callback WA_id to wa_name
@app.callback(
    dash.dependencies.Output('WA_name', 'value'),
    [dash.dependencies.Input('WA_id', 'value')])
def get_name(x):
    # print x
    name = s_tot_2017[s_tot_2017.PWSID == x]['report_agency_name'].unique().tolist()[0]
    # print name
    return name


# Hiddenvariable H1
@app.callback(
    dash.dependencies.Output('h1', 'children'),
    [dash.dependencies.Input('graph2', 'clickData')])
def storeclick1(x):
    # print x, 'text from h1'
    h1 = x['points'][0]['text']
    y1 = h1[:h1.find(' - ')]
    # print y1, 'PWSID from h1'
    return y1


# Hiddenvariable H2
@app.callback(
    dash.dependencies.Output('h2', 'children'),
    [dash.dependencies.Input('graph3', 'clickData')])
def storeclick2(x2):
    # print x2, 'text from h2'
    h2 = x2['points'][0]['text']
    y2 = h2[:h2.find(' - ')]
    # print y2, 'PWSID from h2'
    return y2

if __name__ == '__main__':
    app.run_server(debug=True)
